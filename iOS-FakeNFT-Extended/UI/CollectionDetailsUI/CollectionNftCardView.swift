//
//  CollectionNftCardView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 21.11.25.
//
import SwiftUI

struct CollectionNftCardView: View {
    let model: CatalogItemViewModel
    @Environment(ServicesAssembly.self) private var services
    
    @State private var isFavorite = false
    @State private var isAddedToCart = false
    @State private var isLoadingCart = false
    @State private var isLoadingFavorite = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: model.previewURL) { phase in
                    switch phase {
                    case .empty:
                        Rectangle().fill(Color.segmentInactive)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Rectangle()
                            .fill(Color.segmentInactive)
                            .overlay(Image(systemName: "photo"))
                    @unknown default:
                        Rectangle().fill(Color.segmentInactive)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button(action: handleFavoriteAction) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(isFavorite ? .universalRed : .universalWhite)
                        .padding(10)
                }
                .buttonStyle(.plain)
            }
            
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { index in
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(index < model.starsCount ? .universalYellow : .segmentInactive)
                }
            }
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(model.title)
                        .font(.customFont(.bodyBold))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                    
                    Text(model.priceText)
                        .font(.customFont(.priceCaption))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button(action: handleCartAction) {
                    Image(isAddedToCart ? "fullBasket" : "emptyBasket")
                        .renderingMode(.template)
                }
                .buttonStyle(.plain)
            }
        }
        .alert("Ошибка", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .task {
            await loadInitialState()
        }
    }
    
    // MARK: - Initial state
    
    private func loadInitialState() async {
        await loadCartState()
        await loadFavoriteState()
    }
    
    private func loadCartState() async {
        do {
            let response = try await services.cartService.fetchOrder()
            isAddedToCart = response.nfts.contains(model.nftId)
        } catch { }
    }
    
    private func loadFavoriteState() async {
        do {
            let profile = try await services.profileService.loadProfile(
                userId: RequestConstants.profileUserId
            )
            isFavorite = profile.likes.contains(model.nftId)
        } catch { }
    }
    
    // MARK: - Cart
    
    private func handleCartAction() {
        guard !isLoadingCart else { return }
        isLoadingCart = true
        
        Task {
            do {
                let currentOrder = try await services.cartService.fetchOrder()
                var updatedNfts = currentOrder.nfts
                
                if updatedNfts.contains(model.nftId) {
                    updatedNfts.removeAll { $0 == model.nftId }
                } else {
                    updatedNfts.append(model.nftId)
                }
                
                let response = try await services.cartService.updateOrder(nftIds: updatedNfts)
                
                await MainActor.run {
                    isAddedToCart = response.nfts.contains(model.nftId)
                    isLoadingCart = false
                    NotificationCenter.default.post(name: .cartUpdated, object: nil)
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Ошибка корзины"
                    showError = true
                    isLoadingCart = false
                }
            }
        }
    }
    
    // MARK: - Favorites
    
    private func handleFavoriteAction() {
        guard !isLoadingFavorite else { return }
        
        isLoadingFavorite = true
        
        Task {
            do {
                let likes = try await services.likesService.toggleLike(
                    nftId: model.nftId,
                    userId: RequestConstants.profileUserId
                )
                
                await MainActor.run {
                    isFavorite = likes.contains(model.nftId)
                    isLoadingFavorite = false
                    
                    NotificationCenter.default.post(
                        name: .favoritesUpdated,
                        object: likes
                    )
                }
            } catch {
                
                await MainActor.run {
                    errorMessage = "Ошибка избранного"
                    showError = true
                    isLoadingFavorite = false
                }
            }
        }
    }
}

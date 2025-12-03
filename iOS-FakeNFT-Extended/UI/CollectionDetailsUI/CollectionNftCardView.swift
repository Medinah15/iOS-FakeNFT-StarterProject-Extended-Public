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
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: model.previewURL) { phase in
                    switch phase {
                    case .empty: Rectangle().fill(Color.segmentInactive)
                    case .success(let image): image.resizable().scaledToFill()
                    case .failure: Rectangle().fill(Color.segmentInactive).overlay(Image(systemName: "photo"))
                    @unknown default: Rectangle().fill(Color.segmentInactive)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button(action: { isFavorite.toggle() }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
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
                    Text(model.title).font(.customFont(.bodyBold)).foregroundColor(.textPrimary).lineLimit(1)
                    Text(model.priceText).font(.customFont(.priceCaption)).foregroundColor(.textPrimary).lineLimit(1)
                }
                Spacer()
                
                
                
                Button(action: handleCartAction) {
                    Image(isAddedToCart ? "fullBasket" : "emptyBasket")
                        .renderingMode(.template)
                }
                .buttonStyle(.plain)
                .disabled(isLoadingCart)
            }
        }
        .alert("Ошибка", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .task { await loadCartState() }
    }
    
    private func loadCartState() async {
        do {
            let response = try await services.cartService.fetchOrder()
            isAddedToCart = response.nfts.contains(model.nftId)
        } catch {}
    }
    
    private func handleCartAction() {
        guard !isLoadingCart else { return }
        
        print("\(isAddedToCart ? "Удаляем" : "Добавляем") NFT: \(model.nftId)")
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
                print("Корзина: \(response.nfts)")
                
                await MainActor.run {
                    isAddedToCart = response.nfts.contains(model.nftId)
                    isLoadingCart = false
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
}

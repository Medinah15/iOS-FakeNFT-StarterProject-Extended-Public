//
//  FavouritesNFTListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 24.11.2025.
//
import SwiftUI

struct FavouritesNFTListView: View {
    @StateObject private var viewModel: FavouritesNFTViewModel
    private let allNFTsViewModel: NFTViewModel
    @Environment(\.dismiss) var dismiss
    
    private let columns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7)
    ]
    
    init(allNFTsViewModel: NFTViewModel) {
        _viewModel = StateObject(wrappedValue: FavouritesNFTViewModel(allNFTsViewModel: allNFTsViewModel))
        self.allNFTsViewModel = allNFTsViewModel
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        backButton
                    }
                    ToolbarItem(placement: .principal) {
                        if !viewModel.favoriteNFTs.isEmpty {
                            Text("Избранные NFT (\(viewModel.favoriteNFTs.count))")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.primary)
                        }
                    }
                }
                .onAppear {
                    viewModel.refresh()
                }
        }
    }
    
    // MARK: - Content
    
    private var contentView: some View {
        Group {
            if viewModel.favoriteNFTs.isEmpty {
                emptyStateView
            } else {
                nftGrid
            }
        }
    }
    
    private var nftGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.favoriteNFTs) { nft in
                    FavouritesNFTListRow(
                        nft: nft,
                        isFavorite: allNFTsViewModel.bindingForFavorite(nftId: nft.id),
                        onToggleFavorite: {
                            viewModel.refresh()
                        }
                    )
                    .onTapGesture {
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .refreshable {
            await viewModel.loadFavoriteNFTs()
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("У Вас ещё нет избранных NFT")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
        }
    }
    
    private var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.primary)
        }
    }
}

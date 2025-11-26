//
//  FavouritesNFTListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 24.11.2025.
//

import SwiftUI

struct FavouritesNFTListView: View {
    @State private var viewModel = FavouritesNFTViewModel()
    @Environment(\.dismiss) var dismiss
    
    private let columns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7)
    ]
    
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
                            Text("Избранные NFT")
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
    
    // MARK: - Content View
    private var contentView: some View {
        Group {
            if viewModel.favoriteNFTs.isEmpty {
                emptyStateView
            } else {
                nftGrid
            }
        }
    }
    
    // MARK: - NFT Grid
    private var nftGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.favoriteNFTs) { nft in
                    FavouritesNFTListRow(nft: nft)
                        .onTapGesture {
                            // TODO: Добавить навигацию к деталям NFT
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("У Вас ещё нет избранных NFT")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
        }
    }
    
    // MARK: - Back Button
    private var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.primary)
        }
    }
}

#Preview("With NFTs") {
    struct WithNFTsPreview: View {
        @State private var viewModel = FavouritesNFTViewModel(nfts: [
            NFTModel(type: .mock, id: "1", name: "Archie", image: "https://i.pravatar.cc/150?img=1", author: "John Doe", price: 1.78, rating: 5, isFavorite: true),
            NFTModel(type: .mock, id: "2", name: "Pixi", image: "https://i.pravatar.cc/150?img=2", author: "John Doe", price: 1.78, rating: 5, isFavorite: true),
            NFTModel(type: .mock, id: "3", name: "Melissa", image: "https://i.pravatar.cc/150?img=3", author: "John Doe", price: 1.78, rating: 5, isFavorite: true),
            NFTModel(type: .mock, id: "4", name: "April", image: "https://i.pravatar.cc/150?img=4", author: "John Doe", price: 1.78, rating: 2, isFavorite: true),
            NFTModel(type: .mock, id: "5", name: "Daisy", image: "https://i.pravatar.cc/150?img=5", author: "John Doe", price: 1.78, rating: 1, isFavorite: true),
            NFTModel(type: .mock, id: "6", name: "Lilo", image: "https://i.pravatar.cc/150?img=6", author: "John Doe", price: 1.78, rating: 4, isFavorite: true)
        ])
        
        private let columns = [
            GridItem(.flexible(), spacing: 7),
            GridItem(.flexible(), spacing: 7)
        ]
        
        var body: some View {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.favoriteNFTs) { nft in
                            FavouritesNFTListRow(nft: nft)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                }
                .navigationTitle("Избранные NFT")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }
    
    return WithNFTsPreview()
}

#Preview("Empty State") {
    struct EmptyStatePreview: View {
        @State private var viewModel = FavouritesNFTViewModel(nfts: [])
        
        var body: some View {
            NavigationStack {
                VStack {
                    Spacer()
                    Text("У Вас ещё нет избранных NFT")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.primary)
                    Spacer()
                }
                .navigationTitle(viewModel.favoriteNFTs.isEmpty ? "" : "Избранные NFT")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }
    
    return EmptyStatePreview()
}


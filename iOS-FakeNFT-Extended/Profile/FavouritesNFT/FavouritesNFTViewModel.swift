//
//  FavouritesNFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 24.11.2025.
import Foundation
import SwiftUI

@MainActor
final class FavouritesNFTViewModel: ObservableObject {
    @Published var favoriteNFTs: [NFTModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let allNFTsViewModel: NFTViewModel
    
    private var isRefreshing = false
    
    init(allNFTsViewModel: NFTViewModel) {
        self.allNFTsViewModel = allNFTsViewModel
        setupObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .favoritesUpdated, object: nil)
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(
            forName: .favoritesUpdated,
            object: nil,
            queue: .main
        ) { [weak self] note in
            guard let self else { return }
            Task { @MainActor in
                self.refresh()
            }
        }
    }
    
    // MARK: - Load favorites
    
    func loadFavoriteNFTs() async {
        if isLoading {
            return
        }
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        let allNFTs = allNFTsViewModel.nfts
        guard !allNFTs.isEmpty else {
            favoriteNFTs = []
            return
        }
        
        favoriteNFTs = allNFTs.filter { $0.isFavorite }
    }
    
    // MARK: - Updates
    
    func refresh() {
        guard !isRefreshing else {
            return
        }
        isRefreshing = true
        
        Task {
            await loadFavoriteNFTs()
            await MainActor.run {
                self.isRefreshing = false
            }
        }
    }
}

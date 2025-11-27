//
//  FavouritesNFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 24.11.2025.
//

import Foundation
import SwiftUI

@Observable
class FavouritesNFTViewModel {
    var favoriteNFTs: [NFTModel] = []
    var allNFTsViewModel: NFTViewModel?
    init(allNFTsViewModel: NFTViewModel? = nil) {
        self.allNFTsViewModel = allNFTsViewModel
        loadFavoriteNFTs()
    }
    
    // MARK: - Preview Initializer
    init(nfts: [NFTModel]) {
        self.favoriteNFTs = nfts
    }
    
    // MARK: - NFT Loading
    func loadFavoriteNFTs() {
        // Загружаем из основного ViewModel или из хранилища
        if let allNFTs = allNFTsViewModel?.nfts {
            favoriteNFTs = allNFTs.filter { $0.isFavorite }
        } else {
            // Fallback на загрузку из хранилища
            let realNFTs = NFTModel.load(type: .real)
            let allNFTs = realNFTs.isEmpty ? NFTModel.load(type: .mock) : realNFTs
            // Фильтруем только избранные
            favoriteNFTs = allNFTs.filter { $0.isFavorite }
        }
    }
    // MARK: - NFT Updates
    func toggleFavorite(for nftId: String) {
        // Обновляем в основном ViewModel
        allNFTsViewModel?.toggleFavorite(for: nftId)
        
        // Обновляем локальный список
        loadFavoriteNFTs()
    }
    
    func refresh() {
        loadFavoriteNFTs()
    }
}


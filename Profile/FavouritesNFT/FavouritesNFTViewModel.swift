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
    
    init() {
        loadFavoriteNFTs()
    }
    
    // MARK: - Preview Initializer
    init(nfts: [NFTModel]) {
        self.favoriteNFTs = nfts
    }
    
    // MARK: - NFT Loading
    private func loadFavoriteNFTs() {
        // Загружаем все NFT
        let realNFTs = NFTModel.load(type: .real)
        let allNFTs: [NFTModel]
        
        if realNFTs.isEmpty {
            allNFTs = NFTModel.load(type: .mock)
        } else {
            allNFTs = realNFTs
        }
        
        // Фильтруем только избранные
        favoriteNFTs = allNFTs.filter { $0.isFavorite }
    }
    
    // MARK: - NFT Updates
    func toggleFavorite(for nftId: String) {
        // Обновляем NFT в основном хранилище
        let realNFTs = NFTModel.load(type: .real)
        let allNFTs: [NFTModel]
        
        if realNFTs.isEmpty {
            allNFTs = NFTModel.load(type: .mock)
        } else {
            allNFTs = realNFTs
        }
        
        // Находим и обновляем NFT
        if let index = allNFTs.firstIndex(where: { $0.id == nftId }) {
            let nft = allNFTs[index]
            let updatedNFT = NFTModel(
                type: nft.type,
                id: nft.id,
                name: nft.name,
                image: nft.image,
                author: nft.author,
                price: nft.price,
                rating: nft.rating,
                isFavorite: !nft.isFavorite
            )
            
            var updatedNFTs = allNFTs
            updatedNFTs[index] = updatedNFT
            
            // Сохраняем обновленный массив
            NFTModel.save(updatedNFTs)
            
            // Обновляем локальный список избранных
            loadFavoriteNFTs()
        }
    }
    
    func refresh() {
        loadFavoriteNFTs()
    }
}


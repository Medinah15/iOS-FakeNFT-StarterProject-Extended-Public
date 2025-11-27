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
    init(nftService: NftService, profileService: ProfileService, allNFTsViewModel: NFTViewModel? = nil) {
        self.nftService = nftService
        self.profileService = profileService
        self.allNFTsViewModel = allNFTsViewModel
        Task { await loadFavoriteNFTs() }
    }
    // MARK: - NFT Loading
    func loadFavoriteNFTs() async {
        isLoading = true
        errorMessage = nil
        do {
            // Если есть shared ViewModel, используем его
            if let allNFTs = allNFTsViewModel?.nfts {
                favoriteNFTs = allNFTs.filter { $0.isFavorite }
                isLoading = false
                return
            }
            
            // Иначе загружаем из API
            let profileResponse = try await profileService.loadProfile(userId: "1")
            
            if profileResponse.likes.isEmpty {
                favoriteNFTs = []
                isLoading = false
                return
            }
            
            let nftResponses = try await nftService.loadNFTsByIds(ids: profileResponse.likes)
            
            favoriteNFTs = nftResponses.map { response in
                response.toNFTModel(isFavorite: true)
            }
        } catch {
            errorMessage = "Ошибка загрузки избранных NFT"
            favoriteNFTs = []
        }
        isLoading = false
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


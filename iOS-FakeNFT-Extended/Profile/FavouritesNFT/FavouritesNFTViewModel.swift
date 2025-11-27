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
    var isLoading = false
    var errorMessage: String?
    
    private let nftService: NftService?
    private let profileService: ProfileService?
    var allNFTsViewModel: NFTViewModel?
    
    init(allNFTsViewModel: NFTViewModel? = nil) {
        self.nftService = nil
        self.profileService = nil
        self.allNFTsViewModel = allNFTsViewModel
        Task { await loadFavoriteNFTs() }
    }
    
    // MARK: - Preview Initializer
    init(nfts: [NFTModel]) {
        self.nftService = nil
        self.profileService = nil
        self.allNFTsViewModel = nil
        self.favoriteNFTs = nfts
    }
    
    // MARK: - Full Initializer (для API интеграции)
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
            
            // Иначе загружаем из API (если есть сервисы)
            guard let profileService = profileService, let nftService = nftService else {
                // Fallback на пустой список если нет сервисов
                favoriteNFTs = []
                isLoading = false
                return
            }
            
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
    func toggleFavorite(for nftId: String) async {
        // Обновляем в основном ViewModel (теперь async)
        await allNFTsViewModel?.toggleFavorite(for: nftId)
        
        // Обновляем локальный список
        await loadFavoriteNFTs()
    }
    
    func toggleFavoriteSync(for nftId: String) {
        // Синхронная версия для использования в Binding
        Task {
            await allNFTsViewModel?.toggleFavorite(for: nftId)
            await loadFavoriteNFTs()
        }
    }
    
    func refresh() {
        Task { await loadFavoriteNFTs() }
    }
}


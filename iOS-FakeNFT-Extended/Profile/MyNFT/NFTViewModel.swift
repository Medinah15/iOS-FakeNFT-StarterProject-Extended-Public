//
//  NFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 24.11.2025.
//

import Foundation
import SwiftUI

enum NFTSortType: String, CaseIterable {
    case byPrice = "По цене"
    case byRating = "По рейтингу"
    case byName = "По названию"
    
    var displayName: String {
        return rawValue
    }
}

@Observable
class NFTViewModel {
    var nfts: [NFTModel] = []
    var selectedSortType: NFTSortType = .byRating
    private let nftService: NftService?
    private let profileService: ProfileService?
    private weak var profileViewModel: ProfileViewModel?  // Ссылка для синхронизации
    var isLoading = false
    var errorMessage: String?
    
    private static let sortTypeKey = "nftSortType"
    
    init(nftService: NftService, profileService: ProfileService, profileViewModel: ProfileViewModel? = nil) {
        self.nftService = nftService
        self.profileService = profileService
        self.profileViewModel = profileViewModel
        loadSortType()
        Task {
            await loadNFTs()
            applySorting()
        }
    }
    
    // MARK: - Preview Initializer
    init(nfts: [NFTModel], sortType: NFTSortType = .byRating) {
        self.nfts = nfts
        self.selectedSortType = sortType
        self.nftService = nil
        self.profileService = nil
        self.profileViewModel = nil
        loadSortType()
    }
    
    // MARK: - NFT Loading
    func loadNFTs() async {
        guard let profileService = profileService, let nftService = nftService else {
            // Если нет сервисов (Preview режим), загружаем сохраненные данные
            nfts = NFTModel.load(type: .real)
            if nfts.isEmpty {
                nfts = NFTModel.mockArray()
            }
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Сначала загружаем сохраненные NFT данные
        let savedNFTs = NFTModel.load(type: .real)
        
        do {
            // Загружаем профиль для получения списка NFT ID
            let profileResponse = try await profileService.loadProfile(userId: "1")
            
            if profileResponse.nfts.isEmpty {
                // Если нет NFT на сервере, используем сохраненные данные или пустой массив
                nfts = savedNFTs.isEmpty ? [] : savedNFTs
                isLoading = false
                return
            }
            
            // Загружаем NFT по ID
            let nftResponses = try await nftService.loadNFTsByIds(ids: profileResponse.nfts)
            
            // Преобразуем в NFTModel, используя сохраненное состояние isFavorite если есть
            nfts = nftResponses.map { response in
                // Проверяем, есть ли сохраненный NFT с таким ID
                if let savedNFT = savedNFTs.first(where: { $0.id == response.id }) {
                    // Используем сохраненное состояние isFavorite
                    return response.toNFTModel(isFavorite: savedNFT.isFavorite)
                } else {
                    // Используем состояние с сервера
                    let isFavorite = profileResponse.likes.contains(response.id)
                    return response.toNFTModel(isFavorite: isFavorite)
                }
            }
            
            saveNFTs()
            applySorting()
            
            // Обновляем счетчики в ProfileViewModel после загрузки NFT
            await MainActor.run {
                profileViewModel?.updateMenuItemsCounts()
            }
        } catch {
            errorMessage = "Ошибка загрузки NFT"
            // При ошибке используем сохраненные данные или мок
            if !savedNFTs.isEmpty {
                nfts = savedNFTs
            } else {
                nfts = NFTModel.mockArray()
            }
            
            // Обновляем счетчики даже при ошибке
            await MainActor.run {
                profileViewModel?.updateMenuItemsCounts()
            }
        }
        isLoading = false
    }
    
    func saveNFTs() {
        NFTModel.save(nfts)
    }
    
    // MARK: - NFT Updates
    func updateNFT(_ nft: NFTModel) {
        if let index = nfts.firstIndex(where: { $0.id == nft.id }) {
            nfts[index] = nft
            saveNFTs()
        }
    }
    
    func toggleFavorite(for nftId: String) async {
        guard let index = nfts.firstIndex(where: { $0.id == nftId }) else { return }
        
        let nft = nfts[index]
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
        nfts[index] = updatedNFT
        saveNFTs()
        
        // Синхронизируем с сервером через ProfileViewModel (если есть)
        if let profileViewModel = profileViewModel {
            let favoriteIds = nfts.filter { $0.isFavorite }.map { $0.id }
            await profileViewModel.updateFavorites(nftIds: favoriteIds)
            
            // Обновляем счетчики после изменения избранного
            await MainActor.run {
                profileViewModel.updateMenuItemsCounts()
            }
        }
    }
    
    // Получить Binding для конкретного NFT
    func bindingForFavorite(nftId: String) -> Binding<Bool> {
        Binding(
            get: { self.nfts.first(where: { $0.id == nftId })?.isFavorite ?? false },
            set: { newValue in
                if let index = self.nfts.firstIndex(where: { $0.id == nftId }) {
                    let nft = self.nfts[index]
                    let updatedNFT = NFTModel(
                        type: nft.type,
                        id: nft.id,
                        name: nft.name,
                        image: nft.image,
                        author: nft.author,
                        price: nft.price,
                        rating: nft.rating,
                        isFavorite: newValue
                    )
                    self.nfts[index] = updatedNFT
                    self.saveNFTs()
                    
                    // Синхронизируем с сервером
                    Task {
                        let favoriteIds = self.nfts.filter { $0.isFavorite }.map { $0.id }
                        await self.profileViewModel?.updateFavorites(nftIds: favoriteIds)
                        
                        // Обновляем счетчики после изменения избранного
                        await MainActor.run {
                            self.profileViewModel?.updateMenuItemsCounts()
                        }
                    }
                }
            }
        )
    }
    
    // MARK: - Sorting
    var sortedNFTs: [NFTModel] {
        switch selectedSortType {
        case .byPrice:
            return nfts.sorted { $0.price > $1.price }
        case .byRating:
            return nfts.sorted { $0.rating > $1.rating }
        case .byName:
            return nfts.sorted { $0.name < $1.name }
        }
    }
    
    func sortNFTs() {
        saveSortType()
        nfts = sortedNFTs
        saveNFTs()
    }
    
    private func applySorting() {
        nfts = sortedNFTs
        saveNFTs()
    }
    
    // MARK: - Sort Type Persistence
    private func loadSortType() {
        if let savedSortType = UserDefaults.standard.string(forKey: Self.sortTypeKey),
           let sortType = NFTSortType(rawValue: savedSortType) {
            selectedSortType = sortType
        }
    }
    
    private func saveSortType() {
        UserDefaults.standard.set(selectedSortType.rawValue, forKey: Self.sortTypeKey)
    }
}

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
        rawValue
    }
}

@Observable
class NFTViewModel: ProfileMenuUpdater {
    var nfts: [NFTModel] = []
    var selectedSortType: NFTSortType = .byRating
    private let nftService: NftService?
    private let profileService: ProfileService?
    weak var profileViewModel: ProfileViewModel?
    var isLoading = false
    var errorMessage: String?
    
    private static let sortTypeKey = "nftSortType"
    
    // MARK: - ProfileMenuUpdater
    
    func updateMenuCounts(nftCount: Int, favoriteCount: Int) { }
    
    // MARK: - Init
    
    init(
        nftService: NftService,
        profileService: ProfileService,
        profileViewModel: ProfileViewModel? = nil
    ) {
        self.nftService = nftService
        self.profileService = profileService
        self.profileViewModel = profileViewModel
        loadSortType()
        setupFavoritesObserver()
        Task {
            await loadNFTs()
            applySorting()
        }
    }
    
    init(nfts: [NFTModel], sortType: NFTSortType = .byRating) {
        self.nfts = nfts
        self.selectedSortType = sortType
        self.nftService = nil
        self.profileService = nil
        self.profileViewModel = nil
        loadSortType()
    }
    
    // MARK: - Notification observer
    
    private func setupFavoritesObserver() {
        NotificationCenter.default.addObserver(
            forName: .favoritesUpdated,
            object: nil,
            queue: .main
        ) { [weak self] note in
            guard let self else { return }
            if let likes = note.object as? [String] {
                self.syncFavoritesLocally(likes: likes)
            }
        }
    }
    
    private func syncFavoritesLocally(likes: [String]) {
        var changed = false
        for index in nfts.indices {
            let nft = nfts[index]
            let shouldBeFavorite = likes.contains(nft.id)
            if nft.isFavorite != shouldBeFavorite {
                let updated = NFTModel(
                    type: nft.type,
                    id: nft.id,
                    name: nft.name,
                    image: nft.image,
                    author: nft.author,
                    price: nft.price,
                    rating: nft.rating,
                    isFavorite: shouldBeFavorite
                )
                nfts[index] = updated
                changed = true
            }
        }
        if changed {
            saveNFTs()
        }
    }
    
    // MARK: - NFT Loading
    
    func loadNFTs() async {
        guard let profileService = profileService,
              let nftService = nftService else {
            nfts = NFTModel.load(type: .real)
            if nfts.isEmpty {
                nfts = NFTModel.mockArray()
            }
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let savedNFTs = NFTModel.load(type: .real)
        
        do {
            let profileResponse = try await profileService.loadProfile(
                userId: RequestConstants.profileUserId
            )
            
            if profileResponse.nfts.isEmpty {
                nfts = savedNFTs.isEmpty ? [] : savedNFTs
                isLoading = false
                return
            }
            
            let nftResponses = try await nftService.loadNFTsByIds(ids: profileResponse.nfts)
            
            nfts = nftResponses.map { response in
                if let savedNFT = savedNFTs.first(where: { $0.id == response.id }) {
                    return response.toNFTModel(isFavorite: savedNFT.isFavorite)
                } else {
                    let isFavorite = profileResponse.likes.contains(response.id)
                    return response.toNFTModel(isFavorite: isFavorite)
                }
            }
            
            saveNFTs()
            applySorting()
            
            await MainActor.run {
                profileViewModel?.updateMenuItemsCounts()
            }
        } catch {
            errorMessage = "Ошибка загрузки NFT"
            if !savedNFTs.isEmpty {
                nfts = savedNFTs
            } else {
                nfts = NFTModel.mockArray()
            }
            
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
    }
    
    func bindingForFavorite(nftId: String) -> Binding<Bool> {
        Binding(
            get: {
                self.nfts.first(where: { $0.id == nftId })?.isFavorite ?? false
            },
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

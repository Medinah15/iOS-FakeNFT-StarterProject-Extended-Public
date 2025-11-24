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
    
    private static let sortTypeKey = "nftSortType"
    
    init() {
        loadNFTs()
        loadSortType()
        applySorting()
    }
    
    // MARK: - Preview Initializer
    init(nfts: [NFTModel], sortType: NFTSortType = .byRating) {
        self.nfts = nfts
        self.selectedSortType = sortType
    }
    
    // MARK: - NFT Loading
    private func loadNFTs() {
        let realNFTs = NFTModel.load(type: .real)
        
        if realNFTs.isEmpty {
            nfts = NFTModel.load(type: .mock)
        } else {
            nfts = realNFTs
        }
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
    
    func toggleFavorite(for nftId: String) {
        if let index = nfts.firstIndex(where: { $0.id == nftId }) {
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

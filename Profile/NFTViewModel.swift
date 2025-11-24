//
//  NFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 24.11.2025.
//

import Foundation
import SwiftUI


@Observable
class NFTViewModel {
    var nfts: [NFTModel] = []
    
    init() {
        loadNFTs()
    }
    
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
}

//
//  ProfileResponse+Extensions.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 27.11.2025.
//

import Foundation

extension ProfileResponse {
    func toProfileModel(userId: String) -> ProfileModel {
        // Разбиваем строки nfts и likes на массивы ID
        let nftIds = nfts.flatMap { $0.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) } }
        let favoriteIds = likes.flatMap { $0.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) } }
        
        return ProfileModel(
            type: .real,
            id: userId,
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            nftCount: nftIds.count,
            favoriteCount: favoriteIds.count
        )
    }
    
    // Получить массив ID NFT
    func getNFTIds() -> [String] {
        return nfts.flatMap { $0.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) } }
    }
    
    // Получить массив ID избранного
    func getFavoriteIds() -> [String] {
        return likes.flatMap { $0.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) } }
    }
}


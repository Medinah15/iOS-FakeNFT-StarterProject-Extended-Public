//
//  ProfileResponse+Extensions.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 27.11.2025.
//

import Foundation

extension ProfileResponse {
    func toProfileModel(userId: String) -> ProfileModel {
        // nfts и likes уже массивы в API ответе, не нужно разбивать
        return ProfileModel(
            type: .real,
            id: userId,
            name: name,
            avatar: avatar,
            description: description ?? "", // Используем пустую строку если null
            website: website,
            nftCount: nfts.count,
            favoriteCount: likes.count
        )
    }
    
    // Получить массив ID NFT (уже массив в API ответе)
    func getNFTIds() -> [String] {
        return nfts
    }
    
    // Получить массив ID избранного (уже массив в API ответе)
    func getFavoriteIds() -> [String] {
        return likes
    }
}


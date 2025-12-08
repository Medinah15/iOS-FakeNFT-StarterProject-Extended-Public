//
//  ProfileResponse+Extensions.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 27.11.2025.
//

import Foundation

extension ProfileResponse {
    func toProfileModel(userId: String) -> ProfileModel {
        
        return ProfileModel(
            type: .real,
            id: userId,
            name: name,
            avatar: avatar,
            description: description ?? "",
            website: website,
            nftCount: nfts.count,
            favoriteCount: likes.count
        )
    }
   
    func getNFTIds() -> [String] {
        return nfts
    }
   
    func getFavoriteIds() -> [String] {
        return likes
    }
}


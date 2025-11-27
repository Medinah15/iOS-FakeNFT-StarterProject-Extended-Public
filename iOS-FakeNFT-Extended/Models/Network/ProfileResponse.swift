//
//  ProfileResponse.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 27.11.2025.
//

import Foundation

struct ProfileResponse: Decodable {
    let id: String
    let name: String
    let avatar: String
    let description: String?  // Может быть null в API
    let website: String
    let nfts: [String]  // Это массив ID NFT пользователя
    let likes: [String] // Это массив ID избранного
}

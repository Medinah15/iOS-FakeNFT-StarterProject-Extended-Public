//
//  ProfileResponse.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 27.11.2025.
//

import Foundation

struct ProfileResponse: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]  // Это массив ID NFT пользователя
    let likes: [String] // Это массив ID избранного избранного
}

//
//  NFTModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 23.11.2025.
//

import Foundation

struct NFTModel: Identifiable, Codable {
    let id: String
    let name: String
    let image: String
    let author: String
    let price: Double 
    let rating: Int
    let isFavorite: Bool
}

extension NFTModel {
    // Мок-данные
    static let mockArray: [NFTModel] = [
        NFTModel(
            id: "1",
            name: "Lilo",
            image: "https://example.com/lilo.png",
            author: "John Doe",
            price: 1.78,
            rating: 3,
            isFavorite: true
        ),
        NFTModel(
            id: "2",
            name: "Spring",
            image: "https://example.com/spring.png",
            author: "John Doe",
            price: 1.78,
            rating: 3,
            isFavorite: true
        ),
        NFTModel(
            id: "3",
            name: "April",
            image: "https://example.com/april.png",
            author: "John Doe",
            price: 1.78,
            rating: 3,
            isFavorite: true
        )
    ]
}

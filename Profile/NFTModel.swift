//
//  NFTModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 23.11.2025.
//

import Foundation


enum NFTType: Codable {
    case mock
    case real
}


struct NFTModel: Identifiable, Codable {
    let type: NFTType
    let id: String
    let name: String
    let image: String
    let author: String
    let price: Double
    let rating: Int
    let isFavorite: Bool
    
    
    
    private static let userDefaultsKey = "savedNFTs"
    
    private static let mockData: [NFTModel] = [
        NFTModel(
            type: .mock,
            id: "1",
            name: "Lilo",
            image: "https://picsum.photos/108/108?random=1",
            author: "John Doe",
            price: 1.78,
            rating: 3,
            isFavorite: true
        ),
        NFTModel(
            type: .mock,
            id: "2",
            name: "Spring",
            image: "https://picsum.photos/108/108?random=2",
            author: "John Doe",
            price: 1.78,
            rating: 3,
            isFavorite: true
        ),
        NFTModel(
            type: .mock,
            id: "3",
            name: "April",
            image: "https://picsum.photos/108/108?random=3",
            author: "John Doe",
            price: 1.78,
            rating: 3,
            isFavorite: true
        )
    ]
    
    init(type: NFTType, id: String, name: String, image: String, author: String, price: Double, rating: Int, isFavorite: Bool) {
        self.type = type
        self.id = id
        self.name = name
        self.image = image
        self.author = author
        self.price = price
        self.rating = rating
        self.isFavorite = isFavorite
    }
}

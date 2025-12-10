//
//  NFTModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 23.11.2025.
//

import Foundation

enum NFTType: Codable, Equatable, Sendable {
    case mock
    case real
}

struct NFTModel: Identifiable, Codable, Equatable, Sendable {
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
            name: "Archie",
            image: "https://i.pravatar.cc/150?img=1",
            author: "John Doe",
            price: 1.78,
            rating: 5,
            isFavorite: true
        ),
        NFTModel(
            type: .mock,
            id: "2",
            name: "Pixi",
            image: "https://i.pravatar.cc/150?img=2",
            author: "John Doe",
            price: 1.78,
            rating: 5,
            isFavorite: true
        ),
        NFTModel(
            type: .mock,
            id: "3",
            name: "Melissa",
            image: "https://i.pravatar.cc/150?img=3",
            author: "John Doe",
            price: 1.78,
            rating: 5,
            isFavorite: true
        ),
        NFTModel(
            type: .mock,
            id: "4",
            name: "April",
            image: "https://i.pravatar.cc/150?img=4",
            author: "John Doe",
            price: 1.78,
            rating: 2,
            isFavorite: true
        ),
        NFTModel(
            type: .mock,
            id: "5",
            name: "Daisy",
            image: "https://i.pravatar.cc/150?img=5",
            author: "John Doe",
            price: 1.78,
            rating: 1,
            isFavorite: true
        ),
        NFTModel(
            type: .mock,
            id: "6",
            name: "Lilo",
            image: "https://i.pravatar.cc/150?img=6",
            author: "John Doe",
            price: 1.78,
            rating: 4,
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
    

    static func mockArray() -> [NFTModel] {
        return mockData
    }
    
    // Сохранение массива NFT (только для real типа)
    static func save(_ nfts: [NFTModel]) {
        // Сохраняем только реальные NFT
        let realNFTs = nfts.filter { $0.type == .real }
        if let encoded = try? JSONEncoder().encode(realNFTs) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    // Загрузка массива NFT в зависимости от типа
    static func load(type: NFTType) -> [NFTModel] {
        switch type {
        case .mock:
            return mockData
            
        case .real:
            guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
                  let nfts = try? JSONDecoder().decode([NFTModel].self, from: data) else {
                return []
            }
            return nfts
        }
    }
}


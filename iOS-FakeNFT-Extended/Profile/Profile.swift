//
//  Profile.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 17.11.2025.
//

import Foundation

enum ProfileType: Codable, Sendable {
    case mock
    case real
}

struct ProfileModel: Codable, Sendable {
    let type: ProfileType
    let id: String
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nftCount: Int
    let favoriteCount: Int
    
    private static let userDefaultsKey = "savedProfile"
    
    private static let mockData = ProfileModel(
        type: .mock,
        id: "1",
        name: "Joaquin Phoenix",
        avatar: "https://i.pravatar.cc/150?img=12",
        description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
        website: "JoaquinPhoenix.com",
        nftCount: 112,
        favoriteCount: 11
    )
    
    init(type: ProfileType, id: String, name: String, avatar: String, description: String, website: String, nftCount: Int, favoriteCount: Int) {
        self.type = type
        self.id = id
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.nftCount = nftCount
        self.favoriteCount = favoriteCount
    }
    
    static func mock() -> ProfileModel {
        return mockData
    }
    
    func save() {
        guard type == .real else { return }
        
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: Self.userDefaultsKey)
        }
    }
    
    func load() -> ProfileModel? {
        
        if type == .real {
            guard let data = UserDefaults.standard.data(forKey: Self.userDefaultsKey),
                  let profile = try? JSONDecoder().decode(ProfileModel.self, from: data) else {
                return nil
            }
            return profile
        }
        
        return nil
    }
}

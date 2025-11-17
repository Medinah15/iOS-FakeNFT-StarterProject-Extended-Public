//
//  Profile.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 17.11.2025.
//

import Foundation


struct Profile: Codable {
    let id: String
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nftCount: Int
    let favoriteCount: Int
    
}

extension Profile {
    static let userDefaultsKey = "savedProfile"
    static let mock = Profile(
        id: "1",
        name: "Joaquin Phoenix",
        avatar: "https://i.pravatar.cc/150?img=12",
        description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
        website: "JoaquinPhoenix.com",
        nftCount: 112,
        favoriteCount: 11
    )
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: Self.userDefaultsKey)
        }
    }
    
    static func load() -> Profile? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let profile = try? JSONDecoder().decode(Profile.self, from: data) else {
            return nil
        }
        return profile
    }
}

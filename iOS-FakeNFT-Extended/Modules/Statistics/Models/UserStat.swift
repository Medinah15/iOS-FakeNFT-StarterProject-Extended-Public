//
//  UserStat.swift
//  iOS-FakeNFT-Extended
//
//  Created by Dmitrii Seitsman on 01.12.2025.
//


// MARK: - UserStat Model

struct UserStat: Identifiable {
    let id: String
    let index: Int
    let name: String
    let avatar: String
    let nftsCount: Int
    // Инициализатор для создания UserStat из UserAPI
    init(userAPI: UserAPI, index: Int) {
        self.id = userAPI.id
        self.index = index // Присваиваем индекс на основе позиции в отсортированном списке
        self.name = userAPI.name
        self.avatar = userAPI.avatar
        self.nftsCount = userAPI.nfts.count // Количество NFT - это count массива nfts
    }
}

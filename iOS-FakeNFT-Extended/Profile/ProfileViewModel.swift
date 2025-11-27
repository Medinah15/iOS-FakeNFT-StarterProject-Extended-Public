//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 17.11.2025.
//

import Foundation
import SwiftUI

@Observable
class ProfileViewModel {
    var profile: ProfileModel
    var menuItems: [ProfileMenuItem] = []
    
    init() {
        // Создаем профиль с типом real
        let realProfile = ProfileModel(
            type: .real,
            id: "1",
            name: "",
            avatar: "",
            description: "",
            website: "",
            nftCount: 0,
            favoriteCount: 0
        )
        
        // Пытаемся загрузить реальные данные
        if let loadedProfile = realProfile.load() {
            profile = loadedProfile
        } else {
            // Если нет сохраненных данных, используем мок
            profile = ProfileModel.mock()
        }
        
        setupMenuItems()
    }
    
    private func setupMenuItems() {
        menuItems = [
            ProfileMenuItem(
                id: "myNFTs",
                title: "Мои NFT",
                count: profile.nftCount,
                action: {}
            ),
            ProfileMenuItem(
                id: "favorites",
                title: "Избранные NFT",
                count: profile.favoriteCount,
                action: {}
            )
        ]
    }
    
    func setupMenuActions(onMyNFTsTap: @escaping () -> Void, onFavoritesTap: @escaping () -> Void) {
        menuItems = [
            ProfileMenuItem(
                id: "myNFTs",
                title: "Мои NFT",
                count: profile.nftCount,
                action: onMyNFTsTap
            ),
            ProfileMenuItem(
                id: "favorites",
                title: "Избранные NFT",
                count: profile.favoriteCount,
                action: onFavoritesTap
            )
        ]
    }
    
    func updateMenuItemsCounts() {
        // Сохраняем текущие actions
        let myNFTsAction = menuItems.first(where: { $0.id == "myNFTs" })?.action ?? {}
        let favoritesAction = menuItems.first(where: { $0.id == "favorites" })?.action ?? {}
        
        menuItems = [
            ProfileMenuItem(
                id: "myNFTs",
                title: "Мои NFT",
                count: profile.nftCount,
                action: myNFTsAction
            ),
            ProfileMenuItem(
                id: "favorites",
                title: "Избранные NFT",
                count: profile.favoriteCount,
                action: favoritesAction
            )
        ]
    }
    
    func openWebsite() {
        if let url = URL(string: "https://\(profile.website)") {
            UIApplication.shared.open(url)
        }
    }
    
    func updateProfile(name: String, description: String, website: String, avatar: String) {
        // Создаем новый профиль с типом real
        profile = ProfileModel(
            type: .real,
            id: profile.id,
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            nftCount: profile.nftCount,
            favoriteCount: profile.favoriteCount
        )
        
        // Сохраняем профиль
        profile.save()
        updateMenuItemsCounts()
    }
    
}

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
    var profile: ProfileModel = .mock
    var menuItems: [ProfileMenuItem] = []
    
    init() {
        // Загружаем сохраненный профиль или используем мок
        if let savedProfile = ProfileModel.load() {
            profile = savedProfile
        } else {
            profile = .mock
        }
        setupMenuItems()
    }
    
    private func setupMenuItems() {
        menuItems = [
            ProfileMenuItem(
                id: "myNFTs",
                title: "Мои NFT",
                count: profile.nftCount,
                action: { [weak self] in
                    self?.openMyNFTs()
                }
            ),
            ProfileMenuItem(
                id: "favorites",
                title: "Избранные NFT",
                count: profile.favoriteCount,
                action: { [weak self] in
                    self?.openFavorites()
                }
            )
        ]
    }
    
    func updateMenuItemsCounts() {
        menuItems = [
            ProfileMenuItem(
                id: "myNFTs",
                title: "Мои NFT",
                count: profile.nftCount,
                action: { [weak self] in
                    self?.openMyNFTs()
                }
            ),
            ProfileMenuItem(
                id: "favorites",
                title: "Избранные NFT",
                count: profile.favoriteCount,
                action: { [weak self] in
                    self?.openFavorites()
                }
            )
        ]
    }
    
    func openWebsite() {
        if let url = URL(string: "https://\(profile.website)") {
            UIApplication.shared.open(url)
        }
    }
    
    func updateProfile(name: String, description: String, website: String, avatar: String) {
        profile = ProfileModel(
            id: profile.id,
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            nftCount: profile.nftCount,
            favoriteCount: profile.favoriteCount
        )
        profile.save()
        updateMenuItemsCounts()
    }
    
    func openMyNFTs() {
        // TODO: Навигация к экрану "Мои NFT"
        print("Открыть Мои NFT")
    }
    
    func openFavorites() {
        // TODO: Навигация к экрану "Избранные NFT"
        print("Открыть Избранные NFT")
    }
}

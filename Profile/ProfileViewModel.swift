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
    var profile: Profile = .mock
    var menuItems: [ProfileMenuItem] = []
    
    init() {
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
    
    func openMyNFTs() {
        // TODO: Навигация к экрану "Мои NFT"
        print("Открыть Мои NFT")
    }
    
    func openFavorites() {
        // TODO: Навигация к экрану "Избранные NFT"
        print("Открыть Избранные NFT")
    }
}

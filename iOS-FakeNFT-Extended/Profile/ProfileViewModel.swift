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
    private let profileService: ProfileService
    var isLoading = false
    var errorMessage: String?
    private let userId = "1"  // Пока хардкод, потом будет динамически
    
    init(profileService: ProfileService) {
        self.profileService = profileService
        self.profile = ProfileModel.mock()  // Временный мок
        setupMenuItems()
        Task { await loadProfile() }
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
    func loadProfile() async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await profileService.loadProfile(userId: userId)
            profile = response.toProfileModel(userId: userId)
            profile.save()
            updateMenuItemsCounts()
        } catch {
            errorMessage = "Ошибка загрузки профиля"
            // Fallback на мок данные при ошибке
            profile = ProfileModel.mock()
        }
        isLoading = false
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
    
    func updateProfile(name: String, description: String, website: String, avatar: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let request = ProfileUpdateRequest(
                likes: nil,
                avatar: avatar,
                name: name,
                description: description,
                website: website
            )
            let response = try await profileService.updateProfile(userId: userId, request: request)
            profile = response.toProfileModel(userId: userId)
            profile.save()
            updateMenuItemsCounts()
        } catch {
            errorMessage = "Ошибка обновления профиля"
        }
        isLoading = false
    }
    func updateFavorites(nftIds: [String]) async {
        isLoading = true
        errorMessage = nil
        do {
            let likesString = nftIds.joined(separator: ",")
            let request = ProfileUpdateRequest(
                likes: likesString,
                avatar: nil,
                name: nil,
                description: nil,
                website: nil
            )
            let response = try await profileService.updateProfile(userId: userId, request: request)
            // Обновляем только favoriteCount, остальное оставляем как есть
            profile = ProfileModel(
                type: .real,
                id: profile.id,
                name: profile.name,
                avatar: profile.avatar,
                description: profile.description,
                website: profile.website,
                nftCount: profile.nftCount,
                favoriteCount: response.likes.count
            )
            profile.save()
            updateMenuItemsCounts()
        } catch {
            errorMessage = "Ошибка обновления избранного"
        }
        isLoading = false
    }
}

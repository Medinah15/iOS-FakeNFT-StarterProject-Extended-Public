//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 17.11.2025.
//
import Foundation
import SwiftUI

protocol ProfileMenuUpdater: AnyObject {
    func updateMenuCounts(nftCount: Int, favoriteCount: Int)
}

@Observable
@MainActor
class ProfileViewModel {
    var profile: ProfileModel
    var menuItems: [ProfileMenuItem] = []
    
    private let profileService: ProfileService
    private let urlService: URLService
    
    var isLoading = false
    var errorMessage: String?
    
    private let userId = RequestConstants.profileUserId
    weak var menuUpdater: ProfileMenuUpdater?
    
    private var isProfileLoading = false
    
    init(profileService: ProfileService, urlService: URLService = URLServiceImpl()) {
        self.profileService = profileService
        self.urlService = urlService
        self.profile = ProfileModel.mock()
        
        setupMenuItems()
        setupFavoritesObserver()
        
        if let saved = profile.load() {
            profile = saved
            updateMenuItemsCounts()
        }
    }
    
    private func setupFavoritesObserver() {
        NotificationCenter.default.addObserver(
            forName: .favoritesUpdated,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self else { return }
            
            Task { @MainActor in
                if let likes = notification.object as? [String] {
                    await self.updateFavorites(nftIds: likes)
                } else {
                    self.updateMenuItemsCounts()
                }
            }
        }
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
    
    func setupMenuActions(
        onMyNFTsTap: @escaping () -> Void,
        onFavoritesTap: @escaping () -> Void
    ) {
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
        let myNFTsAction = menuItems.first(where: { $0.id == "myNFTs" })?.action ?? {}
        let favoritesAction = menuItems.first(where: { $0.id == "favorites" })?.action ?? {}
        
        let actualNFTCount: Int
        let actualFavoriteCount: Int
        
        if let nftVM = menuUpdater as? NFTViewModel {
            actualNFTCount = nftVM.nfts.count
            actualFavoriteCount = nftVM.nfts.filter { $0.isFavorite }.count
        } else {
            actualNFTCount = profile.nftCount
            actualFavoriteCount = profile.favoriteCount
        }
        
        menuItems = [
            ProfileMenuItem(
                id: "myNFTs",
                title: "Мои NFT",
                count: actualNFTCount,
                action: myNFTsAction
            ),
            ProfileMenuItem(
                id: "favorites",
                title: "Избранные NFT",
                count: actualFavoriteCount,
                action: favoritesAction
            )
        ]
        
        if profile.nftCount != actualNFTCount || profile.favoriteCount != actualFavoriteCount {
            profile = createUpdatedProfile(
                nftCount: actualNFTCount,
                favoriteCount: actualFavoriteCount
            )
            profile.save()
        }
        
        menuUpdater?.updateMenuCounts(
            nftCount: actualNFTCount,
            favoriteCount: actualFavoriteCount
        )
    }
    
    func loadProfile() async {
        if isProfileLoading {
            return
        }
        isProfileLoading = true
        
        isLoading = true
        errorMessage = nil
        
        if let savedProfile = profile.load() {
            profile = savedProfile
            updateMenuItemsCounts()
        }
        
        do {
            let response = try await profileService.loadProfile(userId: userId)
            
            profile = response.toProfileModel(userId: userId)
            profile.save()
            updateMenuItemsCounts()
            
            await synchronizeNFTsWithServer(likesIds: response.likes)
            updateMenuItemsCounts()
        } catch let networkError as NetworkClientError {
            switch networkError {
            case .httpStatusCode(let code):
                if code == 406 || code == 404 {
                    if profile.type == .mock {
                        profile = ProfileModel.mock()
                    }
                    errorMessage = nil
                } else {
                    errorMessage = "Ошибка загрузки профиля (код: \(code))"
                }
            default:
                errorMessage = "Ошибка загрузки профиля: \(networkError)"
            }
        } catch {
            errorMessage = "Ошибка загрузки профиля: \(error.localizedDescription)"
        }
        
        isLoading = false
        isProfileLoading = false
    }
    
    func openWebsite() {
        guard let url = urlService.makeURL(from: profile.website) else {
            return
        }
        urlService.openURL(url)
    }
    
    func updateProfile(
        name: String,
        description: String,
        website: String,
        avatar: String
    ) async {
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
            
            let response = try await profileService.updateProfile(
                userId: userId,
                request: request
            )
            
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
        
        let newFavoriteCount = nftIds.count
        profile = createUpdatedProfile(
            nftCount: profile.nftCount,
            favoriteCount: newFavoriteCount
        )
        profile.save()
        updateMenuItemsCounts()
        
        await synchronizeNFTsWithServer(likesIds: nftIds)
        
        isLoading = false
    }
    
    private func createUpdatedProfile(
        nftCount: Int,
        favoriteCount: Int
    ) -> ProfileModel {
        ProfileModel(
            type: profile.type,
            id: profile.id,
            name: profile.name,
            avatar: profile.avatar,
            description: profile.description,
            website: profile.website,
            nftCount: nftCount,
            favoriteCount: favoriteCount
        )
    }
    
    private func synchronizeNFTsWithServer(likesIds: [String]) async {
        guard let nftVM = menuUpdater as? NFTViewModel else {
            return
        }
        
        for index in nftVM.nfts.indices {
            let nft = nftVM.nfts[index]
            let shouldBeFavorite = likesIds.contains(nft.id)
            
            if nft.isFavorite != shouldBeFavorite {
                let updatedNFT = NFTModel(
                    type: nft.type,
                    id: nft.id,
                    name: nft.name,
                    image: nft.image,
                    author: nft.author,
                    price: nft.price,
                    rating: nft.rating,
                    isFavorite: shouldBeFavorite
                )
                nftVM.nfts[index] = updatedNFT
            }
        }
        
        nftVM.saveNFTs()
    }
}

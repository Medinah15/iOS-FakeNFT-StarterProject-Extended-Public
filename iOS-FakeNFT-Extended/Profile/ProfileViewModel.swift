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
    private let userId: String = "1"  // Всегда используем "1" для профиля согласно API
    weak var nftViewModel: NFTViewModel?  // Ссылка для синхронизации NFT данных
    
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
        
        // Сначала пытаемся загрузить сохраненный профиль из UserDefaults
        if let savedProfile = profile.load() {
            profile = savedProfile
            updateMenuItemsCounts()
        }
        
        do {
            let response = try await profileService.loadProfile(userId: userId)
            
            // Важно: всегда используем "1" для userId, так как API использует фиксированный ID для профиля
            // response.id содержит токен, а не ID профиля
            profile = response.toProfileModel(userId: userId)
            profile.save()
            updateMenuItemsCounts()
            
            // Синхронизируем NFT данные с сервером только при успешной загрузке
            await synchronizeNFTsWithServer(likesIds: response.likes)
            
            // Обновляем счетчики после синхронизации NFT
            updateMenuItemsCounts()
        } catch let networkError as NetworkClientError {
            // Обработка специфических ошибок сети
            switch networkError {
            case .httpStatusCode(let code):
                if code == 406 || code == 404 {
                    // Профиль не найден - используем сохраненные данные или моковые
                    if profile.type == .mock {
                        // Если уже есть сохраненные данные, используем их
                        // Иначе используем мок
                        if profile.id == "1" && profile.name == "Joaquin Phoenix" {
                            // Это мок, оставляем как есть
                        }
                    }
                    // Не синхронизируем NFT данные с сервером при ошибке
                    errorMessage = nil // Не показываем ошибку пользователю
                } else {
                    print("❌ HTTP ошибка \(code) при загрузке профиля")
                    errorMessage = "Ошибка загрузки профиля (код: \(code))"
                    // Не синхронизируем NFT данные при ошибке
                }
            default:
                print("❌ Ошибка загрузки профиля: \(networkError)")
                errorMessage = "Ошибка загрузки профиля: \(networkError)"
                // Не синхронизируем NFT данные при ошибке
            }
        } catch {
            print("❌ Ошибка загрузки профиля: \(error.localizedDescription)")
            errorMessage = "Ошибка загрузки профиля: \(error.localizedDescription)"
            // Не синхронизируем NFT данные при ошибке
        }
        isLoading = false
    }
    
    func setupMenuActions(onMyNFTsTap: @escaping () -> Void, onFavoritesTap: @escaping () -> Void) {
        // Обновляем счетчики на основе реальных данных из NFTViewModel
        let actualNFTCount = nftViewModel?.nfts.count ?? profile.nftCount
        let actualFavoriteCount = nftViewModel?.nfts.filter { $0.isFavorite }.count ?? profile.favoriteCount
        
        menuItems = [
            ProfileMenuItem(
                id: "myNFTs",
                title: "Мои NFT",
                count: actualNFTCount,
                action: onMyNFTsTap
            ),
            ProfileMenuItem(
                id: "favorites",
                title: "Избранные NFT",
                count: actualFavoriteCount,
                action: onFavoritesTap
            )
        ]
    }
    
    func updateMenuItemsCounts() {
        // Сохраняем текущие actions
        let myNFTsAction = menuItems.first(where: { $0.id == "myNFTs" })?.action ?? {}
        let favoritesAction = menuItems.first(where: { $0.id == "favorites" })?.action ?? {}
        
        // Обновляем счетчики на основе реальных данных из NFTViewModel
        let actualNFTCount = nftViewModel?.nfts.count ?? profile.nftCount
        let actualFavoriteCount = nftViewModel?.nfts.filter { $0.isFavorite }.count ?? profile.favoriteCount
        
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
        
        // Обновляем профиль с актуальными счетчиками
        profile = ProfileModel(
            type: profile.type,
            id: profile.id,
            name: profile.name,
            avatar: profile.avatar,
            description: profile.description,
            website: profile.website,
            nftCount: actualNFTCount,
            favoriteCount: actualFavoriteCount
        )
        profile.save()
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
            
            // Всегда используем "1" для userId
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
        
        // Сначала обновляем локальное состояние избранного
        let newFavoriteCount = nftIds.count
        profile = ProfileModel(
            type: profile.type,
            id: profile.id,
            name: profile.name,
            avatar: profile.avatar,
            description: profile.description,
            website: profile.website,
            nftCount: profile.nftCount,
            favoriteCount: newFavoriteCount
        )
        profile.save()
        updateMenuItemsCounts()
        
        // Синхронизируем локальные NFT данные с новым состоянием избранного
        await synchronizeNFTsWithServer(likesIds: nftIds)
        
        // Пытаемся синхронизировать с сервером (но не критично, если не получится)
        // Если список пустой, не отправляем запрос на сервер, чтобы избежать ошибки 406
        guard !nftIds.isEmpty else {
            // Если список пустой, просто используем локальное состояние
            // Не отправляем запрос на сервер, чтобы избежать ошибки 406
            isLoading = false
            return
        }
        
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
            
            // Обновляем favoriteCount из ответа сервера
            profile = ProfileModel(
                type: .real,
                id: userId,
                name: profile.name,
                avatar: profile.avatar,
                description: profile.description,
                website: profile.website,
                nftCount: profile.nftCount,
                favoriteCount: response.likes.count
            )
            profile.save()
            updateMenuItemsCounts()
            
            // Синхронизируем локальные NFT данные с сервером после успешного обновления
            await synchronizeNFTsWithServer(likesIds: response.likes)
        } catch let networkError as NetworkClientError {
            // Обработка специфических ошибок сети
            switch networkError {
            case .httpStatusCode(let code):
                if code == 406 || code == 404 {
                    // Профиль не найден на сервере или пустой список избранного вызывает ошибку
                    // Используем локальное состояние - это нормально
                    // Локальное состояние уже обновлено выше, просто продолжаем работу
                    print("ℹ️ Профиль не найден на сервере или пустой список избранного. Используем локальное состояние.")
                } else {
                    print("❌ HTTP ошибка \(code) при синхронизации избранного с сервером")
                    // Не показываем ошибку пользователю, так как локально все работает
                }
            default:
                // Не критичная ошибка - локальное состояние уже обновлено
                print("ℹ️ Ошибка синхронизации с сервером. Используем локальное состояние.")
            }
        } catch {
            // Не критичная ошибка - локальное состояние уже обновлено
            print("ℹ️ Ошибка синхронизации: \(error.localizedDescription). Используем локальное состояние.")
        }
        isLoading = false
    }
    
    // Синхронизация локальных NFT данных с сервером после успешного обновления избранного
    private func synchronizeNFTsWithServer(likesIds: [String]) async {
        guard let nftVM = nftViewModel else {
            return
        }
        
        // Загружаем сохраненные NFT данные для сохранения локальных изменений
        let savedNFTs = NFTModel.load(type: .real)
        
        // Обновляем isFavorite для всех NFT на основе ответа сервера
        // Но сохраняем локальные изменения, если они есть
        for index in nftVM.nfts.indices {
            let nft = nftVM.nfts[index]
            
            // Проверяем, есть ли сохраненное локальное состояние для этого NFT
            if let savedNFT = savedNFTs.first(where: { $0.id == nft.id }) {
                // Приоритет сохраненному локальному состоянию (локальные изменения важнее серверных)
                if nft.isFavorite != savedNFT.isFavorite {
                    let updatedNFT = NFTModel(
                        type: nft.type,
                        id: nft.id,
                        name: nft.name,
                        image: nft.image,
                        author: nft.author,
                        price: nft.price,
                        rating: nft.rating,
                        isFavorite: savedNFT.isFavorite
                    )
                    nftVM.nfts[index] = updatedNFT
                }
            } else {
                // Если нет сохраненного состояния, используем состояние с сервера
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
        }
        
        nftVM.saveNFTs()
    }
}

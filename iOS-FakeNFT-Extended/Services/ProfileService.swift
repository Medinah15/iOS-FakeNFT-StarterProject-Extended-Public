//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 27.11.2025.
//


import Foundation

protocol ProfileService {
    func loadProfile(userId: String) async throws -> ProfileResponse
    func updateProfile(userId: String, request: ProfileUpdateRequest) async throws -> ProfileResponse
}

@MainActor
final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadProfile(userId: String) async throws -> ProfileResponse {
        let request = GetProfileRequest(userId: userId)
        return try await networkClient.send(request: request)
    }
    
    func updateProfile(userId: String, request: ProfileUpdateRequest) async throws -> ProfileResponse {
        let networkRequest = UpdateProfileRequest(userId: userId, profileUpdate: request)
        return try await networkClient.send(request: networkRequest)
    }
}

//
//  LikesService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 06.12.25.
//

import Foundation

final class LikesService {
    private let profileService: ProfileService
    
    init(profileService: ProfileService) {
        self.profileService = profileService
    }
    
    func toggleLike(nftId: String, userId: String) async throws -> [String] {
        let profile = try await profileService.loadProfile(userId: userId)
        var likes = profile.likes
        
        if likes.contains(nftId) {
            likes.removeAll { $0 == nftId }
        } else {
            likes.append(nftId)
        }
        
        let likesString = likes.joined(separator: ",")   
        
        let updateRequest = ProfileUpdateRequest(
            likes: likesString,
            avatar: nil,
            name: nil,
            description: nil,
            website: nil
        )
        
        _ = try await profileService.updateProfile(
            userId: userId,
            request: updateRequest
        )
        
        return likes
    }
}

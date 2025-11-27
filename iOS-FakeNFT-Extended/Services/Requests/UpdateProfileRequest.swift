//
//  UpdateProfileRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 27.11.2025.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    let userId: String
    let dto: ProfileUpdateRequest
    
    var httpMethod: HttpMethod { .put }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(userId)")
    }
}

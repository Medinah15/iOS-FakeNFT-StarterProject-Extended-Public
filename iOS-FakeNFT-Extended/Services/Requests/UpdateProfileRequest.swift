//
//  UpdateProfileRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 27.11.2025.
//

import Foundation

struct UpdateProfileRequest: FormURLEncodedRequest {
    let userId: String
    let profileUpdate: ProfileUpdateRequest
    
    var httpMethod: HttpMethod { .put }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(userId)")
    }
    
    var dto: Encodable? { nil }  
    
    var formParameters: [String: String] {
        var params: [String: String] = [:]
        
        if let likes = profileUpdate.likes {
            params["likes"] = likes
        }
        if let avatar = profileUpdate.avatar {
            params["avatar"] = avatar
        }
        if let name = profileUpdate.name {
            params["name"] = name
        }
        if let description = profileUpdate.description {
            params["description"] = description
        }
        if let website = profileUpdate.website {
            params["website"] = website
        }
        
        return params
    }
}

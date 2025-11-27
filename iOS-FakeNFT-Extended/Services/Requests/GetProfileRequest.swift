//
//  GetProfileRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 27.11.2025.
//

import Foundation


struct GetProfileRequest: NetworkRequest {
    let userId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(userId)")
    }
}

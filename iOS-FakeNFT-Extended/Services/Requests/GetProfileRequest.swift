//
//  GetProfileRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 03.12.25.
//

import Foundation

struct GetProfileRequest: NetworkRequest {
    let userId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(userId)")
    }
}

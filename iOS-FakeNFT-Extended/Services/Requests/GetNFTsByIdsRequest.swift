//
//  GetNFTsByIdsRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 27.11.2025.
//

import Foundation

struct GetNFTsByIdsRequest: NetworkRequest {
    let ids: [String]
    
    var endpoint: URL? {
        let idsString = ids.joined(separator: ",")
        var components = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/nft")
        components?.queryItems = [
            URLQueryItem(name: "ids", value: idsString)
        ]
        return components?.url
    }
}

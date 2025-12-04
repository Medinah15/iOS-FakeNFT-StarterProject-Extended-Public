//
//  GetNFTsRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 05.12.25.
//

import Foundation

struct GetNFTsRequest: NetworkRequest {
    let page: Int
    let size: Int
    
    var endpoint: URL? {
        var components = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/nft")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(size)")
        ]
        return components?.url
    }
}

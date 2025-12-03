//
//  OrderRequests.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 03.12.25.
//

import Foundation

// MARK: - GET /api/v1/orders/1
struct OrderGetRequest: NetworkRequest {
    private let path = "/api/v1/orders/1"
    
    var httpMethod: HttpMethod { .get }
    var endpoint: URL? { URL(string: RequestConstants.baseURL + path) }
    var dto: Encodable? { nil }
}

// MARK: - PUT /api/v1/orders/1
struct OrderPutRequest: NetworkRequest, FormURLEncodedRequest {
    private let path = "/api/v1/orders/1"
    let nftIds: [String]
    
    var httpMethod: HttpMethod { .put }
    var endpoint: URL? { URL(string: RequestConstants.baseURL + path) }
    
    var dto: Encodable? { nil }
    
    var formParameters: [String : String] {
        if nftIds.isEmpty {
            return [:]
        } else {
            return ["nfts": nftIds.joined(separator: ",")]
        }
    }
}

// MARK: - POST /api/v1/orders/1
struct OrderPostRequest: NetworkRequest, FormURLEncodedRequest {
    private let path = "/api/v1/orders/1"
    let nftIds: [String]
    
    var httpMethod: HttpMethod { .post }
    var endpoint: URL? { URL(string: RequestConstants.baseURL + path) }
    
    var dto: Encodable? { nil }
    
    var formParameters: [String: String] {
        return [:]
    }
}

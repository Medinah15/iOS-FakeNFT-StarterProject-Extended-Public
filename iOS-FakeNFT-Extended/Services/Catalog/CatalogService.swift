//
//  CatalogService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 13.11.25.
//

import Foundation

// MARK: - Protocol

protocol CatalogService {
    func fetchCollections() async throws -> [CatalogCollection]
    func fetchItems(for collectionID: String) async throws -> [CatalogItem]
}

actor CatalogServiceImpl: CatalogService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCollections() async throws -> [CatalogCollection] {
        let request = CatalogCollectionsRequest()
        return try await networkClient.send(request: request)
    }
    
    func fetchItems(for collectionID: String) async throws -> [CatalogItem] {
        let request = CatalogItemsRequest(collectionID: collectionID)
        return try await networkClient.send(request: request)
    }
}

// MARK: - Requests

struct CatalogCollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
}

struct CatalogItemsRequest: NetworkRequest {
    let collectionID: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(collectionID)/nft")
    }
}

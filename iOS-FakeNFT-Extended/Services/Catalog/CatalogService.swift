//
//  CatalogService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 13.11.25.
//

import Foundation

// MARK: - Errors

enum CatalogServiceError: Error, Sendable {
    case network
    case decoding
    case invalidResponse
    case unknown
}

// MARK: - Protocol

protocol CatalogService {
    func fetchCollections() async throws -> [CatalogCollection]
    func fetchItems(for collectionID: String) async throws -> [CatalogItem]
}

// MARK: - Service Implementation

actor CatalogServiceImpl: CatalogService {
    
    private let networkClient: NetworkClient
    private var collectionsCache: [CatalogCollection]?
    private var itemsCache: [String: [CatalogItem]] = [:]
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCollections() async throws -> [CatalogCollection] {
        if let cache = collectionsCache, !cache.isEmpty {
            return cache
        }
        
        do {
            let request = CatalogCollectionsRequest()
            let collections: [CatalogCollection] = try await networkClient.send(request: request)
            collectionsCache = collections
            return collections
        } catch {
            throw mapError(error)
        }
    }
    
    func fetchItems(for collectionID: String) async throws -> [CatalogItem] {
        if let cached = itemsCache[collectionID], !cached.isEmpty {
            return cached
        }
        
        do {
            let request = CatalogItemsRequest(collectionID: collectionID)
            let items: [CatalogItem] = try await networkClient.send(request: request)
            itemsCache[collectionID] = items
            return items
        } catch {
            throw mapError(error)
        }
    }
    
    // MARK: - Private
    
    private func mapError(_ error: Error) -> Error {
        switch error {
        case NetworkClientError.parsingError:
            return CatalogServiceError.decoding
        case NetworkClientError.httpStatusCode,
            NetworkClientError.urlRequestError,
            NetworkClientError.urlSessionError:
            return CatalogServiceError.network
        default:
            return CatalogServiceError.unknown
        }
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

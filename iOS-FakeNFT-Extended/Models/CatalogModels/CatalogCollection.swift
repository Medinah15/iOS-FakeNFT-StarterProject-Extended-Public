//
//  CatalogCollection.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 12.11.25.
//

import Foundation

struct CatalogCollection: Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let description: String?
    public let coverURL: URL?
    public let authorName: String?
    public let authorURL: URL?
    public let nftCount: Int?
}

extension CatalogCollection {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case title
        case description
        case cover
        case coverURL = "cover_url"
        case author
        case authorName = "author_name"
        case authorSite = "author_site"
        case authorURL = "author_url"
        case nfts
        case nftCount = "nft_count"
        case count
    }
    
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try c.decode(String.self, forKey: .id)
        
        let title = try c.decodeIfPresent(String.self, forKey: .title)
        ?? c.decodeIfPresent(String.self, forKey: .name)
        ?? "Untitled"
        self.title = title
        
        self.description = try c.decodeIfPresent(String.self, forKey: .description)
        
        let coverString = try c.decodeIfPresent(String.self, forKey: .cover)
        ?? c.decodeIfPresent(String.self, forKey: .coverURL)
        self.coverURL = coverString.flatMap { URL(string: $0) }
        
        self.authorName = try c.decodeIfPresent(String.self, forKey: .authorName)
        ?? c.decodeIfPresent(String.self, forKey: .author)
        
        let authorURLString = try c.decodeIfPresent(String.self, forKey: .authorSite)
        ?? c.decodeIfPresent(String.self, forKey: .authorURL)
        self.authorURL = authorURLString.flatMap { URL(string: $0) }
        
        if let cnt = try c.decodeIfPresent(Int.self, forKey: .nftCount) {
            self.nftCount = cnt
        } else if let cnt = try c.decodeIfPresent(Int.self, forKey: .count) {
            self.nftCount = cnt
        } else if let nfts = try c.decodeIfPresent([String].self, forKey: .nfts) {
            self.nftCount = nfts.count
        } else {
            self.nftCount = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(description, forKey: .description)
        try c.encode(coverURL?.absoluteString, forKey: .coverURL)
        try c.encode(authorName, forKey: .authorName)
        try c.encode(authorURL?.absoluteString, forKey: .authorURL)
        try c.encode(nftCount, forKey: .nftCount)
    }
}

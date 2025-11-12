//
//  CatalogItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 12.11.25.
//

import Foundation

public struct CatalogItem: Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let images: [URL]
    public let previewImageURL: URL?
    public let rating: Double?
    public let priceETH: Decimal?
    
    public init(
        id: String,
        title: String,
        images: [URL],
        previewImageURL: URL?,
        rating: Double?,
        priceETH: Decimal?
    ) {
        self.id = id
        self.title = title
        self.images = images
        self.previewImageURL = previewImageURL
        self.rating = rating
        self.priceETH = priceETH
    }
}

extension CatalogItem {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case title
        case image
        case images
        case preview
        case previewURL = "preview_url"
        case rating
        case price
        case priceETH = "price_eth"
        case eth
    }
    
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try c.decode(String.self, forKey: .id)
        
        self.title = try c.decodeIfPresent(String.self, forKey: .title)
        ?? c.decodeIfPresent(String.self, forKey: .name)
        ?? "Untitled"
        
        var urls: [URL] = []
        
        if let arr = try c.decodeIfPresent([String].self, forKey: .images) {
            urls = arr.compactMap { URL(string: $0) }
        } else if let single = try c.decodeIfPresent(String.self, forKey: .image) {
            if let u = URL(string: single) {
                urls = [u]
            }
        }
        self.images = urls
        
        let previewStr = try c.decodeIfPresent(String.self, forKey: .preview)
        ?? c.decodeIfPresent(String.self, forKey: .previewURL)
        self.previewImageURL = previewStr.flatMap { URL(string: $0) } ?? urls.first
        
        if let r = try? c.decodeIfPresent(Double.self, forKey: .rating) {
            self.rating = r
        } else if let rs = try? c.decodeIfPresent(String.self, forKey: .rating),
                  let r = Double(rs) {
            self.rating = r
        } else {
            self.rating = nil
        }
        
        func parseDecimal(_ s: String?) -> Decimal? {
            guard let s, !s.isEmpty else { return nil }
            let cleaned = s
                .replacingOccurrences(of: "ETH", with: "")
                .replacingOccurrences(of: ",", with: ".")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            return Decimal(string: cleaned)
        }
        
        if let d = try? c.decodeIfPresent(Decimal.self, forKey: .priceETH) {
            self.priceETH = d
        } else if let d = try? c.decodeIfPresent(Decimal.self, forKey: .price) {
            self.priceETH = d
        } else if let d = try? c.decodeIfPresent(Decimal.self, forKey: .eth) {
            self.priceETH = d
        } else {
            let s = (try? c.decodeIfPresent(String.self, forKey: .priceETH)) ??
            (try? c.decodeIfPresent(String.self, forKey: .price)) ??
            (try? c.decodeIfPresent(String.self, forKey: .eth)) ?? nil
            self.priceETH = parseDecimal(s ?? nil)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(images.map { $0.absoluteString }, forKey: .images)
        try c.encode(previewImageURL?.absoluteString, forKey: .previewURL)
        try c.encode(rating, forKey: .rating)
        try c.encode(priceETH, forKey: .priceETH)
    }
}

//
//  CatalogItemViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 21.11.25.
//
import Foundation

struct CatalogItemViewModel: Identifiable, Hashable {
    let id = UUID()
    let nftId: String
    let title: String
    let previewURL: URL?
    let rating: Double
    let priceETH: Decimal?
    
    // MARK: - Derived
    
    var priceText: String {
        let value = priceETH ?? 0
        return "\(value) ETH"
    }
    
    var starsCount: Int {
        max(0, min(5, Int(round(rating))))
    }
}

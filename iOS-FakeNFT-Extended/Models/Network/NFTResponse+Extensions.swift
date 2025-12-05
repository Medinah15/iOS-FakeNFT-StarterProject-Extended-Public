//
//  NFTResponse+Extensions.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 27.11.2025.
//

import Foundation

extension NFTResponse {
    func toNFTModel(isFavorite: Bool, authorName: String? = nil) -> NFTModel {
        NFTModel(
            type: .real,
            id: id,
            name: name,
            image: images.first ?? "",
            author: authorName ?? author,
            price: price,
            rating: rating,
            isFavorite: isFavorite
        )
    }
}

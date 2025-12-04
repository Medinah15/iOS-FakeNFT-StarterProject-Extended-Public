//
//  NFTResponse.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 05.12.25.
//

import Foundation

struct NFTResponse: Decodable, Sendable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
    let author: String   
}

//
//  ProfileResponse.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 03.12.25.
//

import Foundation

struct ProfileResponse: Decodable, Sendable {
    let id: String
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let likes: [String]
}

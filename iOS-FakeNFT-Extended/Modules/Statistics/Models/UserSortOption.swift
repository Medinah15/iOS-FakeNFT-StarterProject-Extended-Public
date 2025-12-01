//
//  где.swift
//  iOS-FakeNFT-Extended
//
//  Created by Dmitrii Seitsman on 01.12.2025.
//
enum UserSortOption: String, CaseIterable, Identifiable {
    case byName = "По имени"
    case byNFTCount = "По количеству NFT"
    var id: String { self.rawValue }
}

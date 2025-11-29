//
//  ProfileUpdateRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 27.11.2025.
//


import Foundation


struct ProfileUpdateRequest: Encodable {
    let likes: String?      // ID через запятую: "id1,id2,id3"
    let avatar: String?
    let name: String?
    let description: String?
    let website: String?
}

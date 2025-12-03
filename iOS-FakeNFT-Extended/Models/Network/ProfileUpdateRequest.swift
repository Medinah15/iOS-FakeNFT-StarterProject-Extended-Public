//
//  ProfileUpdateRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 03.12.25.
//
import Foundation

struct ProfileUpdateRequest: Encodable {
    let likes: String?     
    let avatar: String?
    let name: String?
    let description: String?
    let website: String?
}

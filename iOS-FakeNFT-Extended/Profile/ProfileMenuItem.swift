//
//  ProfileMenuItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 17.11.2025.
//

import Foundation
import SwiftUI

struct ProfileMenuItem: Identifiable {
    let id: String
    let title: String
    let count: Int?
    let action: () -> Void
    
    var displayTitle: String {
        if let count = count {
            return "\(title) (\(count))"
        }
        return title
    }
    
    static let myNFTs = ProfileMenuItem(
        id: "myNFTs",
        title: "Мои NFT",
        count: 112,
        action: {}
    )
    
    static let favorites = ProfileMenuItem(
        id: "favorites",
        title: "Избранные NFT",
        count: 11,
        action: {}
    )
}

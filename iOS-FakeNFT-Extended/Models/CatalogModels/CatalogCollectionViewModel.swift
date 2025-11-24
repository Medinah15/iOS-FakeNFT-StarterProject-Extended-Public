//
//  CatalogCollectionViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 16.11.25.
//

import Foundation

struct CatalogCollectionViewModel: Identifiable, Hashable {
    let id: String
    let title: String
    let itemsCountText: String
    let coverURL: URL?         
}

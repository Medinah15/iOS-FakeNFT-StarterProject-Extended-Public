//
//  CollectionDetailsViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 18.11.25.
//

import Foundation
import Observation

@Observable
@MainActor
final class CollectionDetailsViewModel {
    
    // MARK: - Dependencies
    
    private let catalogService: CatalogService
    
    // MARK: - Input
    
    let collectionID: String
    let title: String
    
    // MARK: - Init
    
    init(
        collectionID: String,
        title: String,
        catalogService: CatalogService
    ) {
        self.collectionID = collectionID
        self.title = title
        self.catalogService = catalogService
    }
}

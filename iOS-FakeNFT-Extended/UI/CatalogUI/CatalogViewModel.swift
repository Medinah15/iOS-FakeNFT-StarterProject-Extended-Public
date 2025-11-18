//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 17.11.25.
//

import Foundation
import Observation

@Observable
@MainActor
final class CatalogViewModel {
    
    var collections: [CatalogCollectionViewModel] = []
    
    func onAppear() {
        collections = [
            CatalogCollectionViewModel(
                id: "1",
                title: "Peach",
                itemsCountText: "(11)",
                coverURL: nil
            ),
            CatalogCollectionViewModel(
                id: "2",
                title: "Blue",
                itemsCountText: "(6)",
                coverURL: nil
            ),
            CatalogCollectionViewModel(
                id: "3",
                title: "Brown",
                itemsCountText: "(8)",
                coverURL: nil
            )
        ]
    }
    
    func didSelectCollection(_ collection: CatalogCollectionViewModel) {
    }
}

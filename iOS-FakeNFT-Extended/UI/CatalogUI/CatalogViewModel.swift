//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 17.11.25.
//

//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//

import Foundation
import Observation

@Observable
@MainActor
final class CatalogViewModel {
    
    // MARK: - State
    
    enum State: Equatable {
        case idle
        case loading
        case data
        case empty
        case error(message: String)
    }
    
    // MARK: - Dependencies
    
    private let catalogService: CatalogService
    
    // MARK: - Published properties
    
    private(set) var collections: [CatalogCollectionViewModel] = []
    private(set) var state: State = .idle
    
    // MARK: - Init (DI)
    
    init(catalogService: CatalogService) {
        self.catalogService = catalogService
    }
    
    // MARK: - Public methods
    
    func onAppear() {
        guard case .idle = state else { return }
        loadCollections()
    }
    
    func reload() {
        loadCollections()
    }
    
    func didSelectCollection(_ collection: CatalogCollectionViewModel) {
        print("Selected collection: \(collection.title)")
    }
    
    // MARK: - Private methods
    
    private func loadCollections() {
        state = .loading
        
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let collectionsData = try await catalogService.fetchCollections()
                
                let viewModels = collectionsData.map {
                    CatalogCollectionViewModel(
                        id: $0.id,
                        title: $0.title,
                        itemsCountText: "(\($0.nftCount ?? 0))",
                        coverURL: $0.coverURL
                    )
                }
                
                self.collections = viewModels
                self.state = viewModels.isEmpty ? .empty : .data
                
            } catch {
                self.state = .error(message: makeErrorMessage(from: error))
            }
        }
    }
    
    private func makeErrorMessage(from error: Error) -> String {
        switch error {
        case CatalogServiceError.network:
            return NSLocalizedString("Error.network", comment: "")
        case CatalogServiceError.decoding:
            return NSLocalizedString("Error.decoding", comment: "")
        default:
            return NSLocalizedString("Error.unknown", comment: "")
        }
    }
}

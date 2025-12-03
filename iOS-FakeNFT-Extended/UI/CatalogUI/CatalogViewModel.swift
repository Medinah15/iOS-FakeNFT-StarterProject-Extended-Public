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
    
    // MARK: - Stored data
    
    private var originalCollections: [CatalogCollection] = []
    
    // MARK: - Sort
    
    private static let sortStorageKey = "catalog.sort.type"
    private(set) var sortType: CatalogSortType
    
    // MARK: - Published properties
    
    private(set) var collections: [CatalogCollectionViewModel] = []
    private(set) var state: State = .idle
    
    var selectedCollection: CatalogCollectionViewModel?
    
    // MARK: - Init (DI)
    
    init(catalogService: CatalogService) {
        self.catalogService = catalogService
        self.sortType = Self.loadStoredSortType()
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
        selectedCollection = collection
    }
    
    func updateSort(_ sort: CatalogSortType) {
        sortType = sort
        saveSortType(sort)
        applySortAndBuildViewModels()
    }
    
    // MARK: - Private methods
    
    private func loadCollections() {
        state = .loading
        
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let collectionsData = try await catalogService.fetchCollections()
                
                self.originalCollections = collectionsData
                self.applySortAndBuildViewModels()
                
            } catch {
                self.state = .error(message: makeErrorMessage(from: error))
            }
        }
    }
    
    private func applySortAndBuildViewModels() {
        let sorted: [CatalogCollection]
        
        switch sortType {
        case .title:
            sorted = originalCollections.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
            
        case .nftCount:
            sorted = originalCollections.sorted {
                ($0.nftCount ?? 0) > ($1.nftCount ?? 0)
            }
        }
        
        let viewModels = sorted.map {
            CatalogCollectionViewModel(
                id: $0.id,
                title: $0.title,
                itemsCountText: "(\($0.nftCount ?? 0))",
                coverURL: $0.coverURL
            )
        }
        
        collections = viewModels
        state = viewModels.isEmpty ? .empty : .data
    }
    
    private func makeErrorMessage(from error: Error) -> String {
        switch error {
        case CatalogServiceError.network:
            NSLocalizedString("Error.network", comment: "")
        case CatalogServiceError.decoding:
            NSLocalizedString("Error.decoding", comment: "")
        default:
            NSLocalizedString("Error.unknown", comment: "")
        }
    }
    
    // MARK: - Sort persistence
    
    private static func loadStoredSortType() -> CatalogSortType {
        let defaults = UserDefaults.standard
        
        if let raw = defaults.string(forKey: sortStorageKey),
           let value = CatalogSortType(rawValue: raw) {
            return value
        }
        
        return .nftCount
    }
    
    private func saveSortType(_ sortType: CatalogSortType) {
        let defaults = UserDefaults.standard
        defaults.set(sortType.rawValue, forKey: Self.sortStorageKey)
    }
}

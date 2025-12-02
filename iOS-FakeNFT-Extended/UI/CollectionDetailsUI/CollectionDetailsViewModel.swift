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
    private let nftService: NftService
    
    // MARK: - Input
    
    let collectionID: String
    let title: String
    
    // MARK: - Output
    
    private(set) var state: State = .idle
    private(set) var collection: CatalogCollection?
    private(set) var items: [CatalogItemViewModel] = []
    
    // MARK: - Init (DI)
    
    init(
        collectionID: String,
        title: String,
        catalogService: CatalogService,
        nftService: NftService
    ) {
        self.collectionID = collectionID
        self.title = title
        self.catalogService = catalogService
        self.nftService = nftService
    }
    
    // MARK: - Public
    
    func onAppear() {
        guard case .idle = state else { return }
        load()
    }
    
    func reload() {
        load()
    }
    
    // MARK: - Private
    
    private func load() {
        state = .loading
        
        Task { [weak self] in
            guard let self else { return }
            
            do {
                
                let collections = try await catalogService.fetchCollections()
                
                guard let foundCollection = collections.first(where: { $0.id == self.collectionID }) else {
                    self.collection = nil
                    self.items = []
                    self.state = .empty
                    return
                }
                
                self.collection = foundCollection
                
                let nftIDs = foundCollection.nftIDs
                
                if nftIDs.isEmpty {
                    self.items = []
                    self.state = .empty
                    return
                }
                
                var uniqueIDs: [String] = []
                var seen = Set<String>()
                
                for id in nftIDs {
                    if !seen.contains(id) {
                        seen.insert(id)
                        uniqueIDs.append(id)
                    }
                }
                
                var viewModels: [CatalogItemViewModel] = []
                viewModels.reserveCapacity(uniqueIDs.count)
                
                try await withThrowingTaskGroup(of: CatalogItemViewModel?.self) { group in
                    for id in uniqueIDs {
                        group.addTask { [weak self] in
                            guard let self else { return nil }
                            
                            do {
                                let nft = try await nftService.loadNft(id: id)
                                
                                let fakeRating = Double(Int.random(in: 3...5))
                                return CatalogItemViewModel(
                                    nftId: nft.id,
                                    title: nft.title,
                                    previewURL: nft.images.first,
                                    rating: fakeRating,
                                    priceETH: nil
                                )
                            } catch {
                                
                                return nil
                            }
                        }
                    }
                    
                    for try await vm in group {
                        if let vm {
                            viewModels.append(vm)
                        }
                    }
                }
                
                self.items = viewModels
                self.state = viewModels.isEmpty ? .empty : .data
                
            } catch {
                self.state = .error(message: makeErrorMessage(from: error))
            }
        }
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
}

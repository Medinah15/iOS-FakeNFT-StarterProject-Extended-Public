//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 17.11.25.
//

import SwiftUI

struct CatalogView: View {
    
    // MARK: - Dependencies
    
    @Environment(ServicesAssembly.self) private var servicesAssembly
    
    // MARK: - Properties
    
    @State private var viewModel: CatalogViewModel
    @State private var isErrorAlertPresented = false
    
    // MARK: - Init (DI)
    
    init(viewModel: CatalogViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button {
                    } label: {
                        Image("menu")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 42, height: 42)
                            .padding(.trailing, 9)
                            .foregroundColor(.textPrimary)
                    }
                }
                .frame(height: 42)
                .background(Color.background)
                .padding(.bottom, 20)
                
                content
            }
            .background(Color.background.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                viewModel.onAppear()
            }
            .onChange(of: viewModel.state) { _, newValue in
                if case .error = newValue {
                    isErrorAlertPresented = true
                }
            }
            .alert(
                NSLocalizedString("Error.title", comment: ""),
                isPresented: $isErrorAlertPresented
            ) {
                Button(NSLocalizedString("Error.repeat", comment: "")) {
                    viewModel.reload()
                }
            } message: {
                if case .error(let message) = viewModel.state {
                    Text(message)
                } else {
                    Text("")
                }
            }
            
            .navigationDestination(
                item: $viewModel.selectedCollection
            ) { collection in
                CollectionDetailsView(
                    viewModel: CollectionDetailsViewModel(
                        collectionID: collection.id,
                        title: collection.title,
                        catalogService: servicesAssembly.catalogService
                    )
                )
            }
        }
    }
    
    // MARK: - Content builder
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tint(.textPrimary)
            
        case .data:
            ScrollView {
                LazyVStack(spacing: 21) {
                    ForEach(viewModel.collections) { collection in
                        CatalogCollectionCardView(model: collection)
                            .onTapGesture {
                                viewModel.didSelectCollection(collection)
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 20)
            }
            
        case .empty:
            CatalogEmptyView()
            
        case .error(let message):
            CatalogErrorView(message: message)
        }
    }
}

#if DEBUG
import SwiftUI

#Preview("CatalogView – mock data") {
    // MARK: - Mock data
    
    let mockCollections: [CatalogCollection] = [
        CatalogCollection(
            id: "1",
            title: "Смешарики",
            description: "Весёлая коллекция NFT по мотивам любимого мультика",
            coverURL: URL(string: "https://picsum.photos/400/200?1"),
            authorName: "Funny Studio",
            authorURL: URL(string: "https://example.com/author1"),
            nftCount: 12
        ),
        CatalogCollection(
            id: "2",
            title: "Космические котики",
            description: "Котики, покоряющие космос",
            coverURL: URL(string: "https://picsum.photos/400/200?2"),
            authorName: "Space Cats Lab",
            authorURL: URL(string: "https://example.com/author2"),
            nftCount: 8
        ),
        CatalogCollection(
            id: "3",
            title: "Пиксельные герои",
            description: "Ностальгия по старым играм",
            coverURL: URL(string: "https://picsum.photos/400/200?3"),
            authorName: "Retro Corp",
            authorURL: URL(string: "https://example.com/author3"),
            nftCount: 24
        )
    ]
    
    let mockItems: [CatalogItem] = [
        CatalogItem(
            id: "item-1",
            title: "Смешарик #1",
            images: [URL(string: "https://picsum.photos/400/400?11")!],
            previewImageURL: URL(string: "https://picsum.photos/200/200?11"),
            rating: 4.8,
            priceETH: Decimal(string: "0.12")
        ),
        CatalogItem(
            id: "item-2",
            title: "Космокот #1",
            images: [URL(string: "https://picsum.photos/400/400?12")!],
            previewImageURL: URL(string: "https://picsum.photos/200/200?12"),
            rating: 4.5,
            priceETH: Decimal(string: "0.25")
        )
    ]
    
    // MARK: - Preview service
    
    final class PreviewCatalogService: CatalogService {
        private let collections: [CatalogCollection]
        private let items: [CatalogItem]
        
        init(
            collections: [CatalogCollection],
            items: [CatalogItem]
        ) {
            self.collections = collections
            self.items = items
        }
        
        func fetchCollections() async throws -> [CatalogCollection] {
            collections
        }
        
        func fetchItems(for collectionID: String) async throws -> [CatalogItem] {
            items
        }
    }
    
    // MARK: - Assembly & ViewModel
    
    let networkClient = DefaultNetworkClient()
    let nftStorage = NftStorageImpl()
    let servicesAssembly = ServicesAssembly(
        networkClient: networkClient,
        nftStorage: nftStorage
    )
    
    let previewCatalogService = PreviewCatalogService(
        collections: mockCollections,
        items: mockItems
    )
    
    let viewModel = CatalogViewModel(catalogService: previewCatalogService)
    
    return CatalogView(viewModel: viewModel)
        .environment(servicesAssembly)
}
#endif

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
    @State private var isFilterPresented = false
    
    // MARK: - Init (DI)
    
    init(viewModel: CatalogViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button {
                            isFilterPresented = true
                        } label: {
                            Image(.menu)
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
                if isFilterPresented {
                    Color(red: 26/255,
                          green: 27/255,
                          blue: 34/255)
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                }
            }
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
            .confirmationDialog(
                NSLocalizedString("Catalog.sort.title", comment: ""),
                isPresented: $isFilterPresented,
                titleVisibility: .visible
            ) {
                Button(NSLocalizedString("Catalog.sort.byTitle", comment: "")) {
                    viewModel.updateSort(.title)
                }
                
                Button(NSLocalizedString("Catalog.sort.byNftCount", comment: "")) {
                    viewModel.updateSort(.nftCount)
                }
                
                Button(NSLocalizedString("Catalog.sort.close", comment: ""), role: .cancel) {
                    
                }
            }
            .navigationDestination(
                item: $viewModel.selectedCollection
            ) { collection in
                CollectionDetailsView(
                    viewModel: CollectionDetailsViewModel(
                        collectionID: collection.id,
                        title: collection.title,
                        catalogService: servicesAssembly.catalogService,
                        nftService: servicesAssembly.nftService
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

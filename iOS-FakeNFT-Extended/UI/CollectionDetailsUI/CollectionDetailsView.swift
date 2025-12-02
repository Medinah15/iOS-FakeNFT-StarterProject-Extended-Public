//
//  CollectionDetailsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 18.11.25.
//

import SwiftUI

struct CollectionDetailsView: View {
    
    // MARK: - Properties
    
    @State private var viewModel: CollectionDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Init (DI)
    
    init(viewModel: CollectionDetailsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.background
            
            content
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            viewModel.onAppear()
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
            
        case .error(let message):
            VStack(spacing: 12) {
                CatalogErrorView(message: message)
                Button(NSLocalizedString("Error.repeat", comment: "")) {
                    viewModel.reload()
                }
                .font(.customFont(.bodyBold))
                .foregroundColor(.textButton)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(Color.primary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .empty:
            CatalogEmptyView()
            
        case .data:
            ZStack(alignment: .topLeading) {
                ScrollView {
                    VStack(spacing: 0) {
                        header
                        
                        VStack(alignment: .leading) {
                            infoBlock
                            grid
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 20)
                    }
                }
                
                Button {
                    dismiss()
                } label: {
                    Image("backward")
                        .foregroundColor(.textPrimary)
                        .frame(width: 24, height: 24)
                    
                }
                .padding(.top, 55)
                .padding(.leading, 9)
            }
        }
    }
    // MARK: - Header
    
    private var header: some View {
        AsyncImage(url: viewModel.collection?.coverURL) { phase in
            switch phase {
            case .empty:
                Color.segmentInactive
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                
            case .failure:
                Color.segmentInactive
                    .overlay(Image(systemName: "photo"))
                
            @unknown default:
                Color.segmentInactive
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 310)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Info block
    
    private var infoBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text(viewModel.title)
                .font(.customFont(.headline3))
                .foregroundColor(.textPrimary)
            
            HStack(spacing: 4) {
                Text(NSLocalizedString("Author of the collection:",
                                       comment: "Автор коллекции:"))
                .font(.customFont(.caption2))
                .foregroundColor(.textPrimary)
                
                if let authorName = viewModel.collection?.authorName,
                   !authorName.isEmpty {
                    NavigationLink {
                        WebViewScreen()
                    } label: {
                        Text(authorName)
                            .font(.customFont(.caption1))
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.plain)
                } else {
                    Text(viewModel.collection?.authorName ?? "—")
                        .font(.customFont(.caption1))
                        .foregroundColor(.primary)
                }
                
            }
            .padding(.top, 13)
            
            if let description = viewModel.collection?.description,
               !description.isEmpty {
                Text(description)
                    .font(.customFont(.caption2))
                    .foregroundColor(.textPrimary)
                    .padding(.top, 5)
            }
        }
    }
    
    // MARK: - Grid
    
    private var grid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 9), count: 3)
        
        return LazyVGrid(columns: columns,alignment: .leading, spacing: 12) {
            ForEach(viewModel.items) { item in
                CollectionNftCardView(
                    model: item)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading) 
        .padding(.top, 24)
    }
}

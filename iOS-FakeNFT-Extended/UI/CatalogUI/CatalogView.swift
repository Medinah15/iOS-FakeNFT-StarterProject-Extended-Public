//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 17.11.25.
//
import SwiftUI

struct CatalogView: View {
    
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
            .onChange(of: viewModel.state) { oldValue, newValue in
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
        }
    }
    
    // MARK: - Content builder
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tint(.primary)
            
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

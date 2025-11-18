//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 17.11.25.
//
import SwiftUI

struct CatalogView: View {
    
    @State private var viewModel = CatalogViewModel()
    
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
                
                .background(Color.background)
                
                .padding(.bottom, 20)
                
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
            }
            .background(Color.background.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

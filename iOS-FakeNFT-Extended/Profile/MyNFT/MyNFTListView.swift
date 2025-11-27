//
//  MyNFTListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 23.11.2025.
//

import SwiftUI
import Foundation

struct MyNFTListView: View {
    @State private var viewModel: NFTViewModel
    @State private var showSortDialog = false
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: NFTViewModel? = nil) {
        // Используем Preview инициализатор с пустым массивом, если не передан ViewModel
        _viewModel = State(initialValue: viewModel ?? NFTViewModel(nfts: []))
    }
    
    var body: some View {
        NavigationStack {
            nftList
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        backButton
                    }
                    
                    ToolbarItem(placement: .principal) {
                        if !viewModel.sortedNFTs.isEmpty {
                            Text("Мои NFT")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !viewModel.sortedNFTs.isEmpty {
                            sortButton
                        }
                    }
                }
                .confirmationDialog("Сортировка", isPresented: $showSortDialog, titleVisibility: .visible) {
                    sortDialogContent
                }
        }
    }
    
    // MARK: - NFT List
    private var nftList: some View {
        Group {
            if viewModel.sortedNFTs.isEmpty {
                emptyStateView
            } else {
                List {
                    ForEach(viewModel.sortedNFTs) { nft in
                        NFTListRow(
                            nft: nft,
                            isFavorite: viewModel.bindingForFavorite(nftId: nft.id)
                        )
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .padding(.top, 20)
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("У Вас ещё нет NFT")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
        }
    }
    
    // MARK: - Back Button
    private var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.primary)
        }
    }
    
    // MARK: - Sort Button
    private var sortButton: some View {
        Button(action: {
            showSortDialog = true
        }) {
            Image("SortIcon")
                .resizable()
                .scaledToFit()
                .foregroundColor(.primary)
        }
        .frame(width: 21, height: 21)
        .contentShape(Rectangle())
    }
    
    // MARK: - Sort Dialog Content
    private var sortDialogContent: some View {
        Group {
            ForEach(NFTSortType.allCases, id: \.self) { sortType in
                Button(sortType.displayName) {
                    viewModel.selectedSortType = sortType
                    viewModel.sortNFTs()
                }
            }
            
            Button("Отмена", role: .cancel) {}
        }
    }
}

#Preview("With NFTs") {
    MyNFTListView()
}

#Preview("Empty State") {
    struct EmptyStatePreview: View {
        @State private var viewModel = NFTViewModel(nfts: [], sortType: .byRating)
        
        var body: some View {
            NavigationStack {
                Group {
                    if viewModel.sortedNFTs.isEmpty {
                        VStack {
                            Spacer()
                            Text("У Вас ещё нет NFT")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(viewModel.sortedNFTs) { nft in
                                NFTListRow(
                                    nft: nft,
                                    isFavorite: viewModel.bindingForFavorite(nftId: nft.id)
                                )
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)
                        .padding(.top, 20)
                    }
                }
                .navigationTitle(viewModel.sortedNFTs.isEmpty ? "" : "Мои NFT")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }
    
    return EmptyStatePreview()
}

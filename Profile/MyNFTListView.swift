//
//  MyNFTListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 23.11.2025.
//

import SwiftUI
import Foundation

enum NFTSortType: String, CaseIterable {
    case byPrice = "По цене"
    case byRating = "По рейтингу"
    case byName = "По названию"
    
    var displayName: String {
        return rawValue
    }
}

struct MyNFTListView: View {
    @State private var viewModel = NFTViewModel()
    @State private var selectedSortType: NFTSortType = .byRating
    @State private var showSortDialog = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            nftList
                .navigationTitle("Мои NFT")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        backButton
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        sortButton
                    }
                }
                .confirmationDialog("Сортировка", isPresented: $showSortDialog, titleVisibility: .visible) {
                    sortDialogContent
                }
        }
    }
    
    // MARK: - NFT List
    private var nftList: some View {
        List {
            ForEach(sortedNFTs) { nft in
                NFTListRow(nft: nft)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .padding(.top, 20)
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
                    selectedSortType = sortType
                    sortNFTs()
                }
            }
            
            Button("Отмена", role: .cancel) {}
        }
    }
    
    // MARK: - Computed Properties
    private var sortedNFTs: [NFTModel] {
        switch selectedSortType {
        case .byPrice:
            return viewModel.nfts.sorted { $0.price > $1.price }
        case .byRating:
            return viewModel.nfts.sorted { $0.rating > $1.rating }
        case .byName:
            return viewModel.nfts.sorted { $0.name < $1.name }
        }
    }
    
    // MARK: - Actions
    private func sortNFTs() {
        // Сортировка происходит через computed property sortedNFTs
        // Обновление не требуется, так как sortedNFTs вычисляется динамически
    }
}

#Preview {
    MyNFTListView()
}

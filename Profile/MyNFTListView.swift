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
    @State private var nfts: [NFTModel] = NFTModel.mockArray
    @State private var selectedSortType: NFTSortType = .byRating
    @State private var showSortDialog = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedNFTs) { nft in
                    NFTListRow(nft: nft)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Мои NFT")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSortDialog = true
                    }) {
                        Image("SortIcon")
                            .foregroundColor(.primary)
                    }
                }
            }
            .confirmationDialog("Сортировка", isPresented: $showSortDialog, titleVisibility: .visible) {
                ForEach(NFTSortType.allCases, id: \.self) { sortType in
                    Button(sortType.displayName) {
                        selectedSortType = sortType
                        sortNFTs()
                    }
                }
                
                Button("Отмена", role: .cancel) {}
            }
        }
    }
    
    // Отсортированный массив NFT
    private var sortedNFTs: [NFTModel] {
        switch selectedSortType {
        case .byPrice:
            return nfts.sorted { $0.price > $1.price } // По убыванию цены
        case .byRating:
            return nfts.sorted { $0.rating > $1.rating } // По убыванию рейтинга
        case .byName:
            return nfts.sorted { $0.name < $1.name } // По алфавиту
        }
    }
    
    // Метод сортировки (можно вызывать при изменении)
    private func sortNFTs() {
        nfts = sortedNFTs
    }
}

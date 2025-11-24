//
//  MyNFTListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 23.11.2025.
//

import SwiftUI
import Foundation

struct MyNFTListView: View {
    @State private var viewModel = NFTViewModel()
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
            ForEach(viewModel.sortedNFTs) { nft in
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
                    viewModel.selectedSortType = sortType
                    viewModel.sortNFTs()
                }
            }
            
            Button("Отмена", role: .cancel) {}
        }
    }
}

#Preview {
    MyNFTListView()
}

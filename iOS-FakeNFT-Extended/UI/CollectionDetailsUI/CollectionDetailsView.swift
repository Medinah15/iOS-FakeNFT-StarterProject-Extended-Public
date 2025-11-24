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
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.title)
                .font(.customFont(.headline2))
                .foregroundColor(.textPrimary)
            
            Text("Здесь будет экран коллекции по макету Figma 🙂")
                .font(.customFont(.caption2))
                .foregroundColor(.textSecondary)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.textPrimary)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

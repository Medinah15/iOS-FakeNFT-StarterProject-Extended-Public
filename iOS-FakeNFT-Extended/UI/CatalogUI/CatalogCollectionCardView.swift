//
//  CatalogCollectionCardView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 17.11.25.
//
import SwiftUI

struct CatalogCollectionCardView: View {
    let model: CatalogCollectionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Rectangle()
                .fill(Color.segmentInactive)
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            Text("\(model.title) \(model.itemsCountText)")
                .font(.customFont(.bodyBold))
                .foregroundColor(.textPrimary)
        }
    }
}

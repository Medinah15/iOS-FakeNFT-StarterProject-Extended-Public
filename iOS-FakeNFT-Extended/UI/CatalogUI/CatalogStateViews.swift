//
//  CatalogStateViews.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 18.11.25.
//

import SwiftUI

struct CatalogEmptyView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text(NSLocalizedString("Catalog.empty.title", comment: ""))
                .font(.customFont(.bodyBold))
                .foregroundColor(.textPrimary)
            
            Text(NSLocalizedString("Catalog.empty.subtitle", comment: ""))
                .font(.customFont(.caption2))
                .foregroundColor(.textSecondary)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CatalogErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(NSLocalizedString("Error.title", comment: ""))
                .font(.customFont(.bodyBold))
                .foregroundColor(.textPrimary)
            
            Text(message)
                .font(.customFont(.caption2))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

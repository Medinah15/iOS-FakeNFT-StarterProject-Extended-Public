//
//  CollectionNftCardView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 21.11.25.
//
import SwiftUI

struct CollectionNftCardView: View {
    let model: CatalogItemViewModel
    
    @State private var isFavorite = false
    @State private var isAddedToCart = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: model.previewURL) { phase in
                    switch phase {
                    case .empty:
                        Rectangle().fill(Color.segmentInactive)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Rectangle()
                            .fill(Color.segmentInactive)
                            .overlay(Image(systemName: "photo"))
                    @unknown default:
                        Rectangle().fill(Color.segmentInactive)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button {
                    isFavorite.toggle()
                } label: {
                    Image(systemName: "heart.fill")
                        .foregroundColor(isFavorite ? .universalRed : .universalWhite )
                        .padding(10)
                }
                .buttonStyle(.plain)
            }
            
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { index in
                    let isFilled = index < model.starsCount
                    
                    Image(systemName:"star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(isFilled ? .universalYellow  : .segmentInactive)
                }
            }
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(model.title)
                        .font(.customFont(.bodyBold))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                    
                    Text(model.priceText)
                        .font(.customFont(.priceCaption))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button {
                    isAddedToCart.toggle()
                } label: {
                    Image(isAddedToCart ? "fullBasket" : "emptyBasket")
                        .renderingMode(.template)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

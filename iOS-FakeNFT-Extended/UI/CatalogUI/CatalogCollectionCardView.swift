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
            
            AsyncImage(url: model.coverURL) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.segmentInactive)
                        .frame(height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                case .failure:
                    Rectangle()
                        .fill(Color.segmentInactive)
                        .overlay(Image(systemName: "photo"))
                        .frame(height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                @unknown default:
                    Rectangle()
                        .fill(Color.segmentInactive)
                        .frame(height: 140)
                }
            }
            
            Text("\(model.title) \(model.itemsCountText)")
                .font(.customFont(.bodyBold))
                .foregroundColor(.textPrimary)
        }
    }
}
#Preview("Success") {
    CatalogCollectionCardView(
        model: CatalogCollectionViewModel(
            id: "1",
            title: "Смешарики",
            itemsCountText: "(12)",
            coverURL: URL(string: "https://picsum.photos/400/200")
        )
    )
    .padding()
    .background(Color.background)
}

#Preview("Failure") {
    CatalogCollectionCardView(
        model: CatalogCollectionViewModel(
            id: "2",
            title: "Ошибка загрузки",
            itemsCountText: "(0)",
            coverURL: URL(string: "https://invalid-url") 
        )
    )
    .padding()
    .background(Color.background)
}

#Preview("Empty") {
    CatalogCollectionCardView(
        model: CatalogCollectionViewModel(
            id: "3",
            title: "Без изображения",
            itemsCountText: "(5)",
            coverURL: nil
        )
    )
    .padding()
    .background(Color.background)
}

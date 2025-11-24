//
//  FavouritesNFTListRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 24.11.2025.
//

import SwiftUI

struct FavouritesNFTListRow: View {
    let nft: NFTModel
    @State private var isImageLoaded = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Изображение NFT с сердечком
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: nft.image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .onAppear {
                                isImageLoaded = false
                            }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .onAppear {
                                isImageLoaded = true
                            }
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .onAppear {
                                isImageLoaded = false
                            }
                    @unknown default:
                        ProgressView()
                            .onAppear {
                                isImageLoaded = false
                            }
                    }
                }
                .frame(width: 108, height: 108)
                .cornerRadius(12)
                .clipped()
                
                // Красное сердечко в правом верхнем углу
                if isImageLoaded {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                        .padding(8)
                }
            }
            
            // Информация справа
            VStack(alignment: .leading, spacing: 4) {
                // Название NFT
                Text(nft.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                // Рейтинг (звезды)
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= nft.rating ? "star.fill" : "star")
                            .foregroundColor(index <= nft.rating ? .yellow : .gray)
                            .font(.system(size: 12))
                    }
                }
                
                // Цена в ETH
                Text("\(nft.price, specifier: "%.2f") ETH")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    let mockNFT = NFTModel(
        type: .mock,
        id: "1",
        name: "Archie",
        image: "https://picsum.photos/108/108?random=1",
        author: "John Doe",
        price: 1.78,
        rating: 5,
        isFavorite: true
    )
    
    return FavouritesNFTListRow(nft: mockNFT)
        .padding()
        .previewLayout(.sizeThatFits)
}


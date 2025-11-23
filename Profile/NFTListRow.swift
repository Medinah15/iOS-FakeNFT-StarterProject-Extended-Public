//
//  NFTListRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 23.11.2025.
//

import SwiftUI

struct NFTListRow: View {
    let nft: NFTModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Изображение NFT
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: nft.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 108, height: 108)
                .cornerRadius(12)
                
                // Иконка сердца
                if nft.isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12))
                        .padding(6)
                        .background(Color.red.opacity(0.8))
                        .clipShape(Circle())
                        .padding(6)
                }
            }
            
            // Информация о NFT
            VStack(alignment: .leading, spacing: 4) {
                // Название
                Text(nft.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
                
                // Рейтинг (звезды)
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= nft.rating ? "star.fill" : "star")
                            .foregroundColor(index <= nft.rating ? .yellow : .gray)
                            .font(.system(size: 12))
                    }
                }
                
                // Автор
                Text("OT \(nft.author)")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Цена
            VStack(alignment: .trailing, spacing: 4) {
                Text("Цена")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
                
                Text("\(nft.price, specifier: "%.2f") ETH")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 4)
    }
}

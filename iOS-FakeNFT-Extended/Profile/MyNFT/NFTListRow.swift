//
//  NFTListRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 23.11.2025.
//

import SwiftUI

struct NFTListRow: View {
    let nft: NFTModel
    @Binding var isFavorite: Bool
    @State private var isImageLoaded = false
    
    init(nft: NFTModel, isFavorite: Binding<Bool>) {
        self.nft = nft
        _isFavorite = isFavorite
    }
    
    var body: some View {
        HStack(spacing: 12) {
            
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
            
            if isImageLoaded {
                Button(action: {
                    isFavorite.toggle()
                }) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 17))
                        .foregroundColor(isFavorite ? .red : .white)
                }
                .padding(12)
            }
        }
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(nft.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
               
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= nft.rating ? "star.fill" : "star")
                            .foregroundColor(index <= nft.rating ? Color(UIColor.starRatingYellow) : .gray)
                            .font(.system(size: 12))
                    }
                }
                
                Text("от \(nft.author)")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.black)
            }
            
            Spacer()
           
            VStack(alignment: .leading, spacing: 4) {
                Text("Цена")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.black)
                
                Text("\(nft.price, specifier: "%.2f") ETH")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
            }
            .padding(.trailing, 39)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        NFTListRow(nft: NFTModel.mockArray()[0], isFavorite: .constant(true))
        NFTListRow(nft: NFTModel.mockArray()[1], isFavorite: .constant(false))
        NFTListRow(nft: NFTModel.mockArray()[2], isFavorite: .constant(true))
    }
    .listStyle(.plain)
}

import SwiftUI
import Foundation

struct PaymentMethod: Identifiable, Equatable {
    let id: String
    let name: String
    let ticker: String
    let imageURL: URL?
    let assetName: String?
    
    // MARK: - Computed image
    @ViewBuilder
    var image: some View {
        if let assetName {
            Image(assetName)
                .resizable()
                .scaledToFit()
        } else if let imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let img):
                    img
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "questionmark.circle")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
        }
    }
}

extension PaymentMethod {
    static let mockAll: [PaymentMethod] = [
        .init(id: "btc",  name: "Bitcoin",   ticker: "BTC",  imageURL: nil, assetName: "bitcoin"),
        .init(id: "doge", name: "Dogecoin",  ticker: "DOGE", imageURL: nil, assetName: "doge"),
        .init(id: "usdt", name: "Tether",    ticker: "USDT", imageURL: nil, assetName: "usdt"),
        .init(id: "ape",  name: "ApeCoin",   ticker: "APE",  imageURL: nil, assetName: "ape"),
        .init(id: "sol",  name: "Solana",    ticker: "SOL",  imageURL: nil, assetName: "sol"),
        .init(id: "eth",  name: "Ethereum",  ticker: "ETH",  imageURL: nil, assetName: "eth"),
        .init(id: "ada",  name: "Cardano",   ticker: "ADA",  imageURL: nil, assetName: "ada"),
        .init(id: "shib", name: "Shiba Inu", ticker: "SHIB", imageURL: nil, assetName: "shib")
    ]
}

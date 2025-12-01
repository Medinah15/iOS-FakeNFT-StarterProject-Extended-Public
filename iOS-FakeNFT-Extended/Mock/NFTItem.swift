import Foundation

struct NFTItem: Identifiable {
    let id = UUID()
    let title: String
    let rating: Int
    let price: Double
    let imageName: String
}

extension NFTItem {
    static let mock: [NFTItem] = [
        NFTItem(title: "April", rating: 1, price: 1.78, imageName: "cardApril"),
        NFTItem(title: "Greena", rating: 3, price: 1.78, imageName: "cardGreena"),
        NFTItem(title: "Spring", rating: 5, price: 1.78, imageName: "cardSpring")
    ]
}

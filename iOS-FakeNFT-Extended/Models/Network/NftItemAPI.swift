import Foundation

struct NftItemAPI: Decodable, Identifiable, Sendable {
    let id: String
    let title: String
    let rating: Int
    let price: Double
    let imageURL: URL
}

extension NftItemAPI {
    init(from api: NftAPI) {
        self.id = api.id
        self.title = api.name
        self.rating = api.rating
        self.price = api.price
        self.imageURL = api.images.first
            ?? URL(string: "https://placehold.co/600x600?text=NFT")!
    }
}

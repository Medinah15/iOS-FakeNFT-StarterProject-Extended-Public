import Foundation

struct NftAPI: Decodable, Sendable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let website: URL?
    let createdAt: String
}

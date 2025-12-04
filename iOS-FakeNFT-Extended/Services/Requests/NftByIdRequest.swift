import Foundation

struct NFTRequest: NetworkRequest {
    let id: String
    
    var httpMethod: HttpMethod { .get }
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
    var dto: Encodable? { nil }
}

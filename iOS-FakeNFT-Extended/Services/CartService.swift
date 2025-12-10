
import Foundation

// MARK: - Models
struct OrderResponse: Decodable, Sendable {
    let nfts: [String]
    let id: String
}

struct UpdateOrderDTO: Encodable, Sendable {
    let nfts: [String]
}

// MARK: - Protocol
protocol CartServiceProtocol {
    func fetchOrder() async throws -> OrderResponse
    func updateOrder(nftIds: [String]) async throws -> OrderResponse
    func completeOrder(nftIds: [String]) async throws -> OrderResponse
}

// MARK: - Implementation
actor CartService: CartServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchOrder() async throws -> OrderResponse {
        let request = OrderGetRequest()
        return try await networkClient.send(request: request)
    }
    
    func updateOrder(nftIds: [String]) async throws -> OrderResponse {
        let request = OrderPutRequest(nftIds: nftIds)
        return try await networkClient.send(request: request)
    }
    
    func completeOrder(nftIds: [String]) async throws -> OrderResponse {
        let request = OrderPostRequest(nftIds: nftIds)
        return try await networkClient.send(request: request)
    }
}

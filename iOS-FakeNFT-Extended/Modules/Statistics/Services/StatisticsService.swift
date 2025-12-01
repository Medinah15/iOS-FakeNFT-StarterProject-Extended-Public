import Foundation

protocol StatisticsServiceProtocol {
    func fetchUsers() async throws -> [UserAPI]
    func fetchUser(id: String) async throws -> UserAPI
}

final class StatisticsService: StatisticsServiceProtocol {
    private let network: NetworkClient
    
    init(network: NetworkClient = DefaultNetworkClient()) {
        self.network = network
    }

    func fetchUsers() async throws -> [UserAPI] {
        try await network.send(request: UsersRequest())
    }
    
    func fetchUser(id: String) async throws -> UserAPI {
        try await network.send(request: UserDetailsRequest(id: id))
    }
}

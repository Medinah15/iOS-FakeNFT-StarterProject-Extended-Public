import Foundation

protocol NftService {
    func loadNft(id: String) async throws -> Nft
    func loadNFTs(page: Int, size: Int) async throws -> [NFTResponse]
    func loadNFTsByIds(ids: [String]) async throws -> [NFTResponse]
}

@MainActor
final class NftServiceImpl: NftService {
    
    private let networkClient: NetworkClient
    private let storage: NftStorage
    
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadNft(id: String) async throws -> Nft {
        if let nft = await storage.getNft(with: id) {
            return nft
        }
        
        let request = NFTRequest(id: id)
        let nft: Nft = try await networkClient.send(request: request)
        await storage.saveNft(nft)
        return nft
    }
    
    func loadNFTs(page: Int, size: Int) async throws -> [NFTResponse] {
        let request = GetNFTsRequest(page: page, size: size)
        return try await networkClient.send(request: request)
    }
    func loadNFTsByIds(ids: [String]) async throws -> [NFTResponse] {
        return try await withThrowingTaskGroup(of: NFTResponse.self) { group in
            var results: [NFTResponse] = []
            
            for id in ids {
                group.addTask {
                    let request = NFTRequest(id: id)
                    return try await self.networkClient.send(request: request)
                }
            }
            
            for try await nft in group {
                results.append(nft)
            }
            
            return results
        }
    }
}

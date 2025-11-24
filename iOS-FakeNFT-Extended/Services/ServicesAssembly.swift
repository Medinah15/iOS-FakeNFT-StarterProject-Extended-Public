import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let catalogServiceInternal: CatalogService
    private let cartServiceInternal: CartService
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.catalogServiceInternal = CatalogServiceImpl(networkClient: networkClient)
        self.cartServiceInternal = CartServiceImpl(networkClient: networkClient)
    }
    
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var catalogService: CatalogService {
        catalogServiceInternal
    }
    
    var cartService: CartService {
        cartServiceInternal
    }
}


import Foundation
import UIKit

protocol URLService {
    func openURL(_ url: URL)
    func makeURL(from string: String) -> URL?
}

final class URLServiceImpl: URLService {
    func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
    
    func makeURL(from string: String) -> URL? {
        
        if string.hasPrefix("http://") || string.hasPrefix("https://") {
            return URL(string: string)
        }
        
        return URL(string: "https://\(string)")
    }
}

@Observable
@MainActor
final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let catalogServiceInternal: CatalogService
    private let cartServiceInternal: CartService
    private let profileServiceInternal: ProfileService
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.catalogServiceInternal = CatalogServiceImpl(networkClient: networkClient)
        self.cartServiceInternal = CartService(networkClient: networkClient)
        self.profileServiceInternal = ProfileServiceImpl(networkClient: networkClient)  
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
    
    var profileService: ProfileService {
        ProfileServiceImpl(networkClient: networkClient)
    }
    
    var urlService: URLService {
        URLServiceImpl()
    }
}

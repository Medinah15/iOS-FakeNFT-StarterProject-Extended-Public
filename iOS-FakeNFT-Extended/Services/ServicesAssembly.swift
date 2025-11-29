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
        // Если строка уже содержит протокол, используем как есть
        if string.hasPrefix("http://") || string.hasPrefix("https://") {
            return URL(string: string)
        }
        // Иначе добавляем https://
        return URL(string: "https://\(string)")
    }
}

@Observable
@MainActor
final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    var profileService: ProfileService {
        ProfileServiceImpl(networkClient: networkClient)
    }
    
    var urlService: URLService {
        URLServiceImpl()
    }
}

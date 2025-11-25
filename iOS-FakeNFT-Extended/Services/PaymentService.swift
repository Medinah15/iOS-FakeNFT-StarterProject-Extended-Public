import Foundation

protocol PaymentService {
    func fetchCurrencies() async throws -> [CurrencyAPI]
    func pay(orderId: String, currencyId: String) async throws -> PaymentResultAPI
}

final class PaymentServiceImpl: PaymentService {

    private let network: NetworkClient
    
    init(network: NetworkClient) {
        self.network = network
    }

    func fetchCurrencies() async throws -> [CurrencyAPI] {
        try await network.send(request: GetCurrenciesRequest())
    }
    
    func pay(orderId: String, currencyId: String) async throws -> PaymentResultAPI {
        try await network.send(request: PayOrderRequest(orderId: orderId, currencyId: currencyId))
    }
}

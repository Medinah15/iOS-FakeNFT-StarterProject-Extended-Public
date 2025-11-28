import SwiftUI

@MainActor
final class CartViewModel: ObservableObject {
    
    // MARK: - Published
    @Published private(set) var state: CartState = .loading
    @Published private(set) var currencies: [CurrencyAPI] = []
    
    // MARK: - Dependencies
    private let cartService: CartService
    private let networkClient: NetworkClient
    private let paymentService: PaymentService
    
    // MARK: - Init
    
    init(
        cartService: CartService,
        networkClient: NetworkClient,
        paymentService: PaymentService
    ) {
        self.cartService = cartService
        self.networkClient = networkClient
        self.paymentService = paymentService
    }
    
    /// Init по умолчанию
    convenience init() {
        let client = DefaultNetworkClient()
        let cartService = CartService(networkClient: client)
        let paymentService = PaymentService(network: client)
        
        self.init(
            cartService: cartService,
            networkClient: client,
            paymentService: paymentService
        )
        
        Task {
            await preloadCurrencies()    // грузим валюты заранее
            await loadItems()            // грузим корзину
        }
    }
    
    // MARK: - Reload
    
    func reload() {
        Task { await loadItems() }
    }
    
    // MARK: - Payment integration
    
    private func preloadCurrencies() async {
        do {
            let data = try await paymentService.fetchCurrencies()
            currencies = data
#if DEBUG
            print("ℹ️ Loaded \(data.count) currencies")
#endif
        } catch {
#if DEBUG
            print("⚠️ Failed to preload currencies:", error)
#endif
        }
    }
    
    // MARK: - Delete
    
    func delete(_ item: NftItemAPI) {
        guard case .loaded(var items) = state else { return }
        
        items.removeAll { $0.id == item.id }
        state = items.isEmpty ? .empty : .loaded(items)
        
        Task {
            do {
                let ids = items.map { $0.id }
                _ = try await cartService.updateOrder(nftIds: ids)
            } catch {
#if DEBUG
                print("❌ CartViewModel.delete – updateOrder error:", error)
#endif
                state = .error("Не удалось обновить корзину")
            }
        }
    }
    
    // MARK: - Payment complete (FIXED)
    
    /// После успешной оплаты очищаем корзину локально.

    func handlePaymentSuccess() {
        state = .loading

        Task {
            do {
                // ВАЖНО: для очистки корзины нужен ПУСТОЙ PUT
                _ = try await cartService.updateOrder(nftIds: [])

                state = .empty
            } catch {
                state = .error("Не удалось выполнить оплату")
            }
        }
    }
    
    // MARK: - Sorting
    
    func sortedItems(_ items: [NftItemAPI], by sort: CartSortOption) -> [NftItemAPI] {
        switch sort {
        case .byPrice:
            items.sorted { $0.price > $1.price }
        case .byRating:
            items.sorted { $0.rating > $1.rating }
        case .byName:
            items.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        }
    }
    
    // MARK: - Load Order
    
    private func loadItems() async {
        state = .loading
        
        do {
            let order = try await cartService.fetchOrder()
            
            guard !order.nfts.isEmpty else {
                state = .empty
                return
            }
            
            var items: [NftItemAPI] = []
            items.reserveCapacity(order.nfts.count)
            
            for nftId in order.nfts {
                do {
                    let request = NFTRequest(id: nftId)
                    let apiModel: NftAPI = try await networkClient.send(request: request)
                    items.append(NftItemAPI(from: apiModel))
                } catch {
#if DEBUG
                    print("❌ Failed to load NFT \(nftId):", error)
#endif
                }
            }
            
            state = items.isEmpty ? .empty : .loaded(items)
            
        } catch {
#if DEBUG
            print("❌ CartViewModel.loadItems – fetchOrder error:", error)
#endif
            state = .error("Не удалось загрузить корзину")
        }
    }
}

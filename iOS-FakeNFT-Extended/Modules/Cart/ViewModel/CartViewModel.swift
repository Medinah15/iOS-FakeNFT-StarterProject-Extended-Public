import SwiftUI

@MainActor
final class CartViewModel: ObservableObject {
    
    // MARK: - Published
    @Published private(set) var state: CartState = .loading
    @Published private(set) var currencies: [CurrencyAPI] = []
    
    // MARK: - Dependencies
    private let cartService: CartService
    private let networkClient: NetworkClient
    private let nftService: NftService
    private let paymentService: PaymentService
    
    // MARK: - Init (DI)
    
    init(
        cartService: CartService,
        networkClient: NetworkClient,
        nftService: NftService,
        paymentService: PaymentService
    ) {
        self.cartService = cartService
        self.networkClient = networkClient
        self.nftService = nftService
        self.paymentService = paymentService
        
        Task { @MainActor [weak self] in
            for await _ in NotificationCenter.default.notifications(named: .cartUpdated).map({ _ in () }) {
                print("🔔 CartViewModel reload")
                await self?.loadItems()
            }
        }
    }
    
    convenience init() {
        let client = DefaultNetworkClient()
        let cartService = CartService(networkClient: client)
        let nftStorage = NftStorageImpl()
        let nftService = NftServiceImpl(networkClient: client, storage: nftStorage)
        let paymentService = PaymentService(network: client)
        
        self.init(
            cartService: cartService,
            networkClient: client,
            nftService: nftService,
            paymentService: paymentService
        )
        
        Task {
            await preloadCurrencies()
            await loadItems()
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
    
    func delete(_ item: CartItem) {
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
    
    // MARK: - Payment complete
    
    func handlePaymentSuccess() {
        state = .loading
        
        Task {
            do {
                
                _ = try await cartService.updateOrder(nftIds: [])
                
                state = .empty
            } catch {
                state = .error("Не удалось выполнить оплату")
            }
        }
    }
    
    // MARK: - Sorting
    
    func sortedItems(_ items: [CartItem], by sort: CartSortOption) -> [CartItem] {
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
            
            var items: [CartItem] = []
            items.reserveCapacity(order.nfts.count)
            
            for nftId in order.nfts {
                do {
                    let request = NFTRequest(id: nftId)
                    let apiModel: NftAPI = try await networkClient.send(request: request)
                    
                    let cartItem = CartItem(
                        id: apiModel.id,
                        title: apiModel.name,
                        cover: apiModel.images.first ?? URL(string: "https://placehold.co/600x600?text=NFT")!,
                        rating: apiModel.rating,
                        price: apiModel.price
                    )
                    items.append(cartItem)
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

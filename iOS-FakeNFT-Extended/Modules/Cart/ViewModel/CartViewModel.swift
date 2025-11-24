import SwiftUI

@MainActor
final class CartViewModel: ObservableObject {
    
    // MARK: - Published
    @Published private(set) var state: CartState = .loading
    
    // MARK: - Dependencies
    private let cartService: CartService
    private let networkClient: NetworkClient
    
    // MARK: - Init
    
    /// Основной инициализатор (на него удобно писать тесты)
    init(cartService: CartService, networkClient: NetworkClient) {
        self.cartService = cartService
        self.networkClient = networkClient
    }
    
    /// Удобный init по умолчанию для прода / превью
    convenience init() {
        let client = DefaultNetworkClient()
        let cartService = CartServiceImpl(networkClient: client)
        self.init(cartService: cartService, networkClient: client)
        
        Task { await loadItems() }
    }
    
    // MARK: - Public API
    
    func reload() {
        Task { await loadItems() }
    }
    
    /// Удаление NFT из корзины (оптимистичное)
    func delete(_ item: NftItemAPI) {
        guard case .loaded(var items) = state else { return }
        
        // 1. Локально убираем из массива
        items.removeAll { $0.id == item.id }
        state = items.isEmpty ? .empty : .loaded(items)
        
        // 2. Синхронизируем с бэком
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
    
    /// Вызывается после успешной оплаты
    func handlePaymentSuccess() {
        // если вдруг по какой-то причине корзина уже пустая — просто обновим состояние
        guard case .loaded(let items) = state, !items.isEmpty else {
            state = .empty
            return
        }
        
        state = .loading
        
        Task {
            do {
                let ids = items.map { $0.id }
                _ = try await cartService.completeOrder(nftIds: ids)
                state = .empty
            } catch {
#if DEBUG
                print("❌ CartViewModel.handlePaymentSuccess – completeOrder error:", error)
#endif
                state = .error("Не удалось выполнить оплату")
            }
        }
    }
    
    // MARK: - Sorting
    
    func sortedItems(_ items: [NftItemAPI], by sort: CartSortOption) -> [NftItemAPI] {
        switch sort {
        case .byPrice:
            return items.sorted { $0.price > $1.price }
        case .byRating:
            return items.sorted { $0.rating > $1.rating }
        case .byName:
            return items.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        }
    }
    
    // MARK: - Private
    
    /// Загрузка корзины и деталей NFT
    private func loadItems() async {
        state = .loading
        
        do {
            // 1. Тянем заказ (id-шники NFT)
            let order = try await cartService.fetchOrder()
            
            guard !order.nfts.isEmpty else {
                state = .empty
                return
            }
            
            // 2. Для каждого id тянем /api/v1/nft/{id} и мапим в NftItemAPI
            var items: [NftItemAPI] = []
            for nftId in order.nfts {
                do {
                    let request = NFTRequest(id: nftId)
                    let apiModel: NftAPI = try await networkClient.send(request: request)
                    let normalized = NftItemAPI(from: apiModel)
                    items.append(normalized)
                } catch {
#if DEBUG
                    print("❌ CartViewModel.loadItems – failed to load NFT \(nftId):", error)
#endif
                    // одного битого NFT игнорируем, остальные показываем
                    continue
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

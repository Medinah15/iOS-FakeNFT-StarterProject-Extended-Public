import SwiftUI

// MARK: - CartViewModel

final class CartViewModel: ObservableObject {
    
    // MARK: - Published properties
    @Published var state: CartState = .loading
    
    // MARK: - Initialization
    init() {
        loadItems()
    }
    
    // MARK: - Private methods
    private func loadItems() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let items = NFTItem.mock
            self.state = items.isEmpty ? .empty : .loaded(items)
        }
    }
    
    // MARK: - Public methods
    func delete(_ item: NFTItem) {
        guard case .loaded(var items) = state else { return }
        
        items.removeAll { $0.id == item.id }
        
        state = items.isEmpty ? .empty : .loaded(items)
    }
    
    func sortedItems(_ items: [NFTItem], by sort: SortOption) -> [NFTItem] {
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
}

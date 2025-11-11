import SwiftUI

final class CartViewModel: ObservableObject {
    @Published var items: [NFTItem] = NFTItem.mock

    var totalPrice: Double {
        items.reduce(0) { $0 + $1.price }
    }

    func delete(_ item: NFTItem) {
        items.removeAll { $0.id == item.id }
    }

    func sortedItems(by sort: CartView.SortOption) -> [NFTItem] {
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

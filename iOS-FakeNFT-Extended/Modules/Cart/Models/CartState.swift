import Foundation

// MARK: - CartItem

struct CartItem: Identifiable, Sendable, Equatable {
    let id: String
    let title: String
    let cover: URL?
    let rating: Int
    let price: Double
}

// MARK: - CartState

enum CartState {
    case loading
    case empty
    case loaded([CartItem])
    case error(String)
}

import Foundation

// MARK: - CartState
enum CartState {
    case loading
    case empty
    case loaded([NFTItem])
    case error(String)
}

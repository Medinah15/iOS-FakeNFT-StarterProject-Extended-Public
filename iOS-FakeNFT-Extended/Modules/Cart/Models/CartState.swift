import Foundation

// MARK: - CartState
enum CartState {
    case loading
    case empty
    case loaded([NftItemAPI])
    case error(String)
}

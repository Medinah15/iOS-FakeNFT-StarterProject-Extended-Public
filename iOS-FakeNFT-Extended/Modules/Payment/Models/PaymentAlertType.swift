import Foundation

enum PaymentAlertType: Identifiable {
    case success
    case error
    
    var id: Int {
        switch self {
        case .success: return 1
        case .error:   return 2
        }
    }
}

import SwiftUI

@MainActor
final class PaymentViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var methods: [PaymentMethod] = PaymentMethod.all
    @Published var selectedMethod: PaymentMethod?
    @Published var isPaymentInProgress = false
    @Published var alertType: PaymentAlertType?
    
    // MARK: - Actions
    func select(_ method: PaymentMethod) {
        selectedMethod = method
    }
    
    func startPayment() {
        guard selectedMethod != nil, !isPaymentInProgress else { return }
        
        isPaymentInProgress = true
        
        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            
            isPaymentInProgress = false
            
            // здесь потом будет результат реального запроса
            let success = Bool.random()
            alertType = success ? .success : .error
        }
    }
}

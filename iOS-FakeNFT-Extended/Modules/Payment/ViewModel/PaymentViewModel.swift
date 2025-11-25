import SwiftUI

@MainActor
final class PaymentViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var methods: [PaymentMethod] = []
    @Published var selectedMethod: PaymentMethod?
    @Published var isPaymentInProgress = false
    @Published var alertType: PaymentAlertType?
    
    // MARK: - Dependencies
    private let paymentService: PaymentService
    private let orderId: String
    
    // MARK: - Init
    init(
        orderId: String = "1",
        paymentService: PaymentService = PaymentServiceImpl(network: DefaultNetworkClient())
    ) {
        self.orderId = orderId
        self.paymentService = paymentService
        
        Task { await loadCurrencies() }
    }
    
    // MARK: - Load Currencies
    private func loadCurrencies() async {
        do {
            let currencies = try await paymentService.fetchCurrencies()
            
            // API → UI mapping
            self.methods = currencies.map { currency in
                let url = URL(string: currency.image)
                
                return PaymentMethod(
                    id: currency.id,
                    name: currency.title,
                    ticker: currency.name,
                    imageURL: url,
                    assetName: nil
                )
            }
            
            print("ℹ️ Loaded \(methods.count) payment methods")
            
        } catch {
            print("❌ Failed to load currencies:", error)
            
            // fallback на локальные моки (иконки из ассетов)
            self.methods = PaymentMethod.mockAll
        }
    }
    
    // MARK: - User actions
    func select(_ method: PaymentMethod) {
        selectedMethod = method
    }
    
    func startPayment() {
        guard let selectedMethod else { return }
        guard !isPaymentInProgress else { return }

        isPaymentInProgress = true
        
        Task {
            do {
                let result = try await paymentService.pay(
                    orderId: orderId,
                    currencyId: selectedMethod.id
                )
                
                isPaymentInProgress = false
                
                alertType = result.success ? .success : .error
                
            } catch {
                isPaymentInProgress = false
                print("❌ Payment error:", error)
                alertType = .error
            }
        }
    }
}

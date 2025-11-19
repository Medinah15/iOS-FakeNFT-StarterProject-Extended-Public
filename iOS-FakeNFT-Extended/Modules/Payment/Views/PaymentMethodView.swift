import SwiftUI

struct PaymentMethodView: View {
    
    let onPaymentSuccess: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PaymentViewModel()
    @State private var isAgreementPresented = false
    @State private var isPaymentSuccessPresented = false
    
    private let columns = [
        GridItem(.fixed(168), spacing: 7),
        GridItem(.fixed(168), spacing: 7)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 7) {
                    ForEach(viewModel.methods) { method in
                        PaymentMethodCell(
                            method: method,
                            isSelected: viewModel.selectedMethod == method,
                            onTap: { viewModel.select(method) }
                        )
                    }
                }
                .padding(.top, 24)
                .padding(.bottom, 16)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                
                PaymentBottomSection(
                    isPaymentEnabled: viewModel.selectedMethod != nil,
                    isPaymentInProgress: viewModel.isPaymentInProgress,
                    onAgreementTap: { isAgreementPresented = true },
                    onPayTap: { viewModel.startPayment() }
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity)
            .background(
                Color.segmentInactive
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .sheet(isPresented: $isAgreementPresented) {
            AgreementView(
                url: URL(string: "https://yandex.ru/legal/practicum_termsofuse")!
            )
        }
        .onChange(of: viewModel.alertType) { oldValue, newValue in
            guard let newValue else { return }
            switch newValue {
            case .success:
                isPaymentSuccessPresented = true
                viewModel.alertType = nil
            case .error:
                break
            }
        }
        .alert(item: $viewModel.alertType) { type in
            switch type {
            case .success:
                return Alert(
                    title: Text("Оплата прошла успешно"),
                    dismissButton: .default(Text("OK"))
                )
            case .error:
                return Alert(
                    title: Text("Ошибка оплаты"),
                    message: Text("Не удалось выполнить платёж."),
                    primaryButton: .default(Text("Повторить")) {
                        viewModel.startPayment()
                    },
                    secondaryButton: .cancel(Text("Отмена"))
                )
            }
        }
        .fullScreenCover(isPresented: $isPaymentSuccessPresented) {
            PaymentSuccessView {
                onPaymentSuccess()
            }
        }
    }
}


// MARK: - Header

private extension PaymentMethodView {
    var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
            
            Text("Выберите способ оплаты")
                .font(.customFont(.headline4))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Color.clear.frame(width: 24, height: 24)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        
    }
}


// MARK: - Preview

#Preview {
    PaymentMethodView(onPaymentSuccess: {})
}

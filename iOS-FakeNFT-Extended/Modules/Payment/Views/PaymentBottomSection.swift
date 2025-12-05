import SwiftUI

struct PaymentBottomSection: View {
    let isPaymentEnabled: Bool
    let isPaymentInProgress: Bool
    let onAgreementTap: () -> Void
    let onPayTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            agreementText
                .padding(.horizontal, 16)
                .padding(.top, 20)
            
            Button(action: onPayTap) {
                HStack {
                    if isPaymentInProgress {
                        ProgressView()
                            .tint(.textButton)
                    }
                    
                    Text("Оплатить")
                        .font(.customFont(.bodyBold))
                }
                .foregroundColor(.textButton)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.textPrimary)
                .cornerRadius(16)
                .opacity(isPaymentEnabled ? 1.0 : 0.5)
            }
            .disabled(!isPaymentEnabled || isPaymentInProgress)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .clipShape(
            RoundedCorner(radius: 12, corners: [.topLeft, .topRight])
        )
    }
    
    private var agreementText: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Совершая покупку, вы соглашаетесь с условиями")
                .font(.customFont(.caption2))
                .foregroundColor(.textPrimary.opacity(0.6))
            
            Button(action: onAgreementTap) {
                Text("Пользовательского соглашения")
                    .font(.customFont(.caption2))
                    .foregroundColor(.blue)
                    .underline()
            }
        }
    }
}


#Preview("PaymentBottomSection") {
    VStack(spacing: 0) {
        
        PaymentBottomSection(
            isPaymentEnabled: true,
            isPaymentInProgress: false,
            onAgreementTap: {},
            onPayTap: {}
        )
        
        PaymentBottomSection(
            isPaymentEnabled: false,
            isPaymentInProgress: false,
            onAgreementTap: {},
            onPayTap: {}
        )
        
        PaymentBottomSection(
            isPaymentEnabled: true,
            isPaymentInProgress: true,
            onAgreementTap: {},
            onPayTap: {}
        )
    }
    .background(Color.background)
}

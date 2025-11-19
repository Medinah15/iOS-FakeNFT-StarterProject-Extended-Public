import SwiftUI

struct PaymentMethodCell: View {
    let method: PaymentMethod
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.universalBlack)
                    
                    Image(method.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 31.5, height: 31.5)
                }
                .frame(width: 36, height: 36)
                .padding(.leading, 12)
                .padding(.vertical, 5)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(method.name)
                        .font(.customFont(.caption2))
                        .foregroundColor(.textPrimary)
                    
                    Text(method.ticker)
                        .font(.customFont(.caption2))
                        .foregroundColor(.universalGreen)
                }
                .padding(.leading, 4)
                
                Spacer()
            }
            .frame(width: 168, height: 46)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.segmentInactive))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.textPrimary: .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview("PaymentMethodCell — Preview") {
    VStack(spacing: 20) {
        
        PaymentMethodCell(
            method: PaymentMethod(
                name: "Bitcoin",
                ticker: "BTC",
                iconName: "btc"
            ),
            isSelected: false,
            onTap: {}
        )
        
        PaymentMethodCell(
            method: PaymentMethod(
                name: "Ethereum",
                ticker: "ETH",
                iconName: "eth"
            ),
            isSelected: true,
            onTap: {}
        )
    }
    .padding()
    .background(Color.background)
}


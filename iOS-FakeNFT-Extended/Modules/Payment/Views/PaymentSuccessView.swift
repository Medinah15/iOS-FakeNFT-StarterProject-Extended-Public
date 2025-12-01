import SwiftUI

struct PaymentSuccessView: View {
    
    let backToCart: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            
            Image("paymentSuccess")
                .resizable()
                .scaledToFit()
                .frame(width: 278, height: 278)
            
            Text("Успех! Оплата прошла, поздравляем с покупкой!")
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .padding(.horizontal, 36)
                .font(.customFont(.headline3))
            
            Spacer()
            
            Button(action: backToCart) {
                Text("Вернуться в корзину")
                    .foregroundColor(.textButton)
                    .font(Font.customFont(.headline4))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.textPrimary)
                    .cornerRadius(16)
            }
            .padding(16)
        }
        
    }
}
#Preview {
    PaymentSuccessView(
        backToCart: {}
    )
}

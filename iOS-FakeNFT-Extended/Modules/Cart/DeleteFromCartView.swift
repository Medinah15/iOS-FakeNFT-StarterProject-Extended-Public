import SwiftUI

struct DeleteFromCartView: View {
    let item: NFTItem
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // Затемнение и размытие фона
            VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                .opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isPresented = false
                    }
                }
            
            // Контент диалога
            VStack(spacing: 20) {
                // NFT иконка
                Image(item.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .cornerRadius(16)
                
                // Текст
                Text("Вы уверены, что хотите\nудалить объект из корзины?")
                    .multilineTextAlignment(.center)
                    .font(.customFont(.caption2))
                    .foregroundColor(.textPrimary)
                
                // Кнопки
                HStack(spacing: 16) {
                    Button {
                        print("Удалить NFT \(item.title)")
                        withAnimation(.easeInOut) {
                            isPresented = false
                        }
                    } label: {
                        Text("Удалить")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.red)
                            .frame(width: 127, height: 44)
                            .background(Color.black)
                            .cornerRadius(12)
                    }
                    
                    Button {
                        withAnimation(.easeInOut) {
                            isPresented = false
                        }
                    } label: {
                        Text("Вернуться")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 127, height: 44)
                            .background(Color.black)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .opacity(0.9)
            )
            .padding(.horizontal, 40)
        }
        .transition(.opacity.combined(with: .scale))
        .animation(.easeInOut(duration: 0.25), value: isPresented)
    }
}

// MARK: - Вспомогательный блюр
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

#Preview("DeleteFromCartView") {
    DeleteFromCartView(item: .mock.first!, isPresented: .constant(true))
}

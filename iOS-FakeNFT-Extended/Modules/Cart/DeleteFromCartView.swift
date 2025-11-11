import SwiftUI

struct DeleteFromCartView: View {
    let item: NFTItem
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                .ignoresSafeArea()
                .overlay(Color.white.opacity(0.05))
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        onCancel()
                    }
                }

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
                    Button(action: onConfirm) {
                        Text("Удалить")
                            .font(.customFont(.bodyRegular))
                            .foregroundColor(.red)
                            .frame(width: 127, height: 44)
                            .background(Color.textPrimary)
                            .cornerRadius(12)
                    }

                    Button(action: onCancel) {
                        Text("Вернуться")
                            .font(.customFont(.bodyRegular))
                            .foregroundColor(.textButton)
                            .frame(width: 127, height: 44)
                            .background(Color.textPrimary)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(24)
            .padding(.horizontal, 40)
        }
    }
}

// MARK: - VisualEffectBlur helper
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

#Preview {
    DeleteFromCartView(
        item: .mock.first!,
        onConfirm: {},
        onCancel: {}
    )
}

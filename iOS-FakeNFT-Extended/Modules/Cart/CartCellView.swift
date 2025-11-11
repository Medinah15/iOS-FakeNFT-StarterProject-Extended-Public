import SwiftUI

struct CartCellView: View {
    let item: NFTItem
    let onDelete: () -> Void

    private let imageSize: CGFloat = 108
    private let starSize: CGFloat = 12
    @State private var showDeleteConfirm = false

    var body: some View {
        ZStack {
            // Основная ячейка
            HStack(alignment: .center, spacing: 20) {
                // Изображение NFT
                Image(item.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                // Текстовая часть
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title)
                        .font(.customFont(.bodyBold))
                        .foregroundColor(.textPrimary)

                    // Звёзды
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(index < item.rating ? "starsFill" : "stars")
                                .resizable()
                                .frame(width: starSize, height: starSize)
                        }
                    }

                    // Цена
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Цена")
                            .font(.customFont(.caption2))

                        Text("\(String(format: "%.2f", item.price)) ETH")
                            .font(.customFont(.bodyBold))
                            .foregroundColor(.textPrimary)
                    }
                    .padding(.top, 12)
                }

                Spacer()

                // Кнопка удаления
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        showDeleteConfirm = true
                    }
                } label: {
                    Image("trashX")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
            }
            .frame(height: 140)
            .padding(.vertical, 4)

            if showDeleteConfirm {
                ZStack {
                    // Размытый фон поверх корзины
                    VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                        .opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut) { showDeleteConfirm = false }
                        }

                    // Контент по центру
                    DeleteFromCartView(item: item, isPresented: $showDeleteConfirm)
                }
                .transition(.opacity.combined(with: .scale))
                .zIndex(10)
            }
        }
    }
}

#Preview("CartCellView", traits: .sizeThatFitsLayout) {
    VStack(spacing: 0) {
        ForEach(NFTItem.mock) { item in
            CartCellView(item: item, onDelete: {})
            Divider()
        }
    }
    .padding()
}

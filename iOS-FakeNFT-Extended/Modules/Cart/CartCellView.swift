import SwiftUI

struct CartCellView: View {
    let item: NFTItem
    let onDeleteTap: () -> Void

    private let imageSize: CGFloat = 108
    private let starSize: CGFloat = 12

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            // === Превью NFT ===
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: imageSize, height: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            // === Текстовая часть ===
            VStack(alignment: .leading, spacing: 8) {
                // Название NFT
                Text(item.title)
                    .font(.customFont(.bodyBold))
                    .foregroundColor(.textPrimary)

                // Рейтинг
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { index in
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

            // === Кнопка удаления ===
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    onDeleteTap()
                }
            }) {
                Image("trashX")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(4)
            }
            .buttonStyle(.plain)
        }
        .frame(height: 140)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

#Preview("CartCellView") {
    VStack(spacing: 0) {
        ForEach(NFTItem.mock) { item in
            CartCellView(item: item) {
                print("Tapped delete for \(item.title)")
            }
            Divider()
        }
    }
    .padding()
    .background(Color.background)
}

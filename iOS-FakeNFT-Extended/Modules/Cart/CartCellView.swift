import SwiftUI

struct CartCellView: View {
    let item: NFTItem
    let onDelete: () -> Void

    private let imageSize: CGFloat = 108
    private let starSize: CGFloat = 12

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            // Изображение NFT
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: imageSize, height: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            // VStack с текстом и рейтингом
            VStack(alignment: .leading, spacing: 8) {
                // Название
                Text(item.title)
                    .font(.customFont(.bodyBold))
                    .foregroundColor(.primary)

                // Рейтинг — звёзды
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(index < item.rating ? "starsFill" : "stars")
                            .resizable()
                            .frame(width: starSize, height: starSize)
                    }
                }
                .frame(height: starSize)

                // Цена
                VStack(alignment: .leading, spacing: 4) {
                    Text("Цена")
                        .font(.customFont(.caption2))

                    Text("\(String(format: "%.2f", item.price)) ETH")
                        .font(.customFont(.bodyBold))
                        .foregroundColor(.primary)
                }
                .padding(.top, 12)
            }

            Spacer()

            // Кнопка удаления
            Button(action: onDelete) {
                Image("trashX")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            .padding(.vertical, 50)
        }
        .frame(height: 140)
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

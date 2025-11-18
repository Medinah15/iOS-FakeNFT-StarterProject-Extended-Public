import SwiftUI

// MARK: - Constants

private enum Constants {
    static let imageSize: CGFloat = 108
    static let starSize: CGFloat = 12

    static let filledStarImage = "starsFill"
    static let emptyStarImage  = "stars"
    static let trashImage      = "trashX"

    static let priceLabel      = "Цена"
    static let priceFormat     = "%.2f"
}

// MARK: - CartCellView

struct CartCellView: View {
    
    // MARK: - Properties
    let item: NFTItem
    let onDeleteTap: () -> Void
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            
            previewImage
            textSection
            
            Spacer()
            
            deleteButton
        }
        .frame(height: 140)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}


// MARK: - Subviews

private extension CartCellView {
    
    // MARK: Preview Image
    var previewImage: some View {
        Image(item.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: Constants.imageSize, height: Constants.imageSize)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: Text Section
    var textSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            title
            rating
            price
        }
    }
    
    // MARK: Title
    var title: some View {
        Text(item.title)
            .font(.customFont(.bodyBold))
            .foregroundColor(.textPrimary)
    }
    
    // MARK: Rating
    var rating: some View {
        HStack(spacing: 4) {
            ForEach(0..<5, id: \.self) { index in
                Image(index < item.rating ? Constants.filledStarImage : Constants.emptyStarImage)
                    .resizable()
                    .frame(width: Constants.starSize, height: Constants.starSize)
            }
        }
    }
    
    // MARK: Price
    var price: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Constants.priceLabel)
                .font(.customFont(.caption2))
            
            Text("\(String(format: Constants.priceFormat, item.price)) ETH")
                .font(.customFont(.bodyBold))
                .foregroundColor(.textPrimary)
        }
        .padding(.top, 12)
    }
    
    // MARK: Delete Button
    var deleteButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                onDeleteTap()
            }
        }) {
            Image(Constants.trashImage)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.textPrimary)
                .padding(4)
        }
        .buttonStyle(.plain)
    }
}


// MARK: - Preview

#Preview("CartCellView") {
    VStack(spacing: .zero) {
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

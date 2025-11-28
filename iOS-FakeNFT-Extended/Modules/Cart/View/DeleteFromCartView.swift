import SwiftUI

// MARK: - Constants

private enum Constants {
    static let imageSize: CGFloat = 120
    static let cornerRadius: CGFloat = 16

    static let modalPadding: CGFloat = 24
    static let modalHorizontalPadding: CGFloat = 40

    static let buttonWidth: CGFloat = 127
    static let buttonHeight: CGFloat = 44

    static let confirmTitle = "Удалить"
    static let cancelTitle  = "Вернуться"

    static let questionText =
        "Вы уверены, что хотите\nудалить объект из корзины?"
}

// MARK: - DeleteFromCartView

struct DeleteFromCartView: View {
    let item: NftItemAPI
    let onConfirm: () -> Void
    let onCancel: () -> Void

    // MARK: - Body
    var body: some View {
        ZStack {
            backgroundLayer
            modalContent
        }
    }
}


// MARK: - Subviews

private extension DeleteFromCartView {

    // MARK: Background
    var backgroundLayer: some View {
        BlurView(style: .systemUltraThinMaterialDark)
            .ignoresSafeArea()
            .overlay(Color.black.opacity(0.4))
            .onTapGesture {
                withAnimation(.easeInOut) {
                    onCancel()
                }
            }
    }

    // MARK: Modal
    var modalContent: some View {
        VStack(spacing: 20) {

            // NFT preview
            AsyncImage(url: item.imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                        .cornerRadius(Constants.cornerRadius)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.imageSize * 0.6,
                               height: Constants.imageSize * 0.6)
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                        .background(Color.segmentInactive)
                        .cornerRadius(Constants.cornerRadius)
                @unknown default:
                    EmptyView()
                }
            }

            // Text
            Text(Constants.questionText)
                .multilineTextAlignment(.center)
                .font(.customFont(.caption2))
                .foregroundColor(.textPrimary)

            // Buttons
            HStack(spacing: 16) {
                confirmButton
                cancelButton
            }

        }
        .padding(Constants.modalPadding)
        .padding(.horizontal, Constants.modalHorizontalPadding)
    }

    // MARK: Buttons
    var confirmButton: some View {
        Button(action: onConfirm) {
            Text(Constants.confirmTitle)
                .font(.customFont(.bodyRegular))
                .foregroundColor(.red)
                .frame(width: Constants.buttonWidth, height: Constants.buttonHeight)
                .background(Color.textPrimary)
                .cornerRadius(12)
        }
    }

    var cancelButton: some View {
        Button(action: onCancel) {
            Text(Constants.cancelTitle)
                .font(.customFont(.bodyRegular))
                .foregroundColor(.textButton)
                .frame(width: Constants.buttonWidth, height: Constants.buttonHeight)
                .background(Color.textPrimary)
                .cornerRadius(12)
        }
    }
}


// MARK: - Preview

#Preview {
    let mockItem = NftItemAPI(
        id: "1",
        title: "April",
        rating: 4,
        price: 12.34,
        imageURL: URL(string: "https://placehold.co/200x200?text=NFT")!
    )

    return DeleteFromCartView(
        item: mockItem,
        onConfirm: {},
        onCancel: {}
    )
}

import SwiftUI
import Combine

struct CartView: View {
    @Binding var isSortMenuPresented: Bool
    @Binding var sortOption: SortOption
    let onDeleteRequest: (NFTItem) -> Void

    @StateObject private var viewModel = CartViewModel()

    enum SortOption: String, CaseIterable {
        case byPrice = "По цене"
        case byRating = "По рейтингу"
        case byName   = "По названию"
    }

    var body: some View {
        VStack(spacing: 0) {
            // Навбар
            HStack {
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        isSortMenuPresented.toggle()
                    }
                } label: {
                    Image("menu")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 42, height: 42)
                        .padding(.trailing, 9)
                        .foregroundColor(.textPrimary)
                }
            }
            .frame(height: 42)
            .background(Color.background)
            .padding(.top, 2)

            // Контент
            if viewModel.items.isEmpty {
                Spacer()
                Text("Корзина пуста")
                    .font(.customFont(.bodyBold))
                    .foregroundColor(.textPrimary)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(viewModel.sortedItems(by: sortOption)) { item in
                            CartCellView(item: item) {
                                onDeleteRequest(item)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 4)
                }

                Divider()

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(viewModel.items.count) NFT")
                            .font(.customFont(.caption2))
                            .foregroundColor(.textPrimary)

                        Text(String(format: "%.2f ETH", viewModel.totalPrice))
                            .font(.customFont(.bodyBold))
                            .foregroundColor(.priceGreen)
                    }

                    Spacer()

                    Button {
                        print("Оплата")
                    } label: {
                        Text("К оплате")
                            .font(.customFont(.bodyBold))
                            .foregroundColor(.textButton)
                            .frame(height: 44)
                            .frame(minWidth: 240)
                            .background(Color.textPrimary)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color.segmentInactive)
            }
        }
        .background(Color.background.ignoresSafeArea())
        .onReceive(NotificationCenter.default.publisher(for: .deleteNFTItem)) { note in
            guard let item = note.object as? NFTItem else { return }
            withAnimation(.easeInOut) {
                viewModel.delete(item)
            }
        }
    }
}


#Preview("CartView") {
    CartView(
        isSortMenuPresented: .constant(false),
        sortOption: .constant(.byName),
        onDeleteRequest: { item in
            print("Удалено из превью: \(item.title)")
        }
    )
}

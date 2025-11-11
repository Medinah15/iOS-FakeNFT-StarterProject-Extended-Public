import SwiftUI

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
            // === Навбар ===
            HStack {
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        isSortMenuPresented.toggle()
                    }
                } label: {
                    Image("menu")
                        .resizable()
                        .frame(width: 42, height: 42)
                        .padding(.trailing, 9)
                }
            }
            .frame(height: 42)
            .background(Color.background)
            .padding(.top, 2)

            // === Контент ===
            if viewModel.items.isEmpty {
                VStack {
                    Spacer()
                    Text("Корзина пуста")
                        .font(.customFont(.bodyBold))
                        .foregroundColor(.textPrimary)
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(viewModel.sortedItems(by: sortOption)) { item in
                            CartCellView(item: item) {
                                withAnimation(.easeInOut) {
                                    viewModel.delete(item)
                                    onDeleteRequest(item)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 4)
                }

                Divider()

                // === Нижняя панель ===
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
                            .foregroundColor(.textOnPrimary)
                            .frame(height: 44)
                            .frame(minWidth: 240)
                            .background(Color.segmentActive)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color.segmentInactive)
            }
        }
        .background(Color.background.ignoresSafeArea())
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

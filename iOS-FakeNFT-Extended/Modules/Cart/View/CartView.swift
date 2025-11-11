import SwiftUI

struct CartView: View {
    @Binding var isSortMenuPresented: Bool
    @Binding var sortOption: SortOption
    let onDeleteRequest: (NFTItem) -> Void

    @State private var items: [NFTItem] = NFTItem.mock

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
            if items.isEmpty {
                // Пустое состояние
                VStack {
                    Spacer()
                    Text("Корзина пуста")
                        .font(.customFont(.bodyBold))
                        .foregroundColor(.textPrimary)
                    Spacer()
                }
            } else {
                // Список товаров
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(sortedItems) { item in
                            CartCellView(item: item) {
                                withAnimation(.easeInOut) {
                                    deleteItem(item)
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
                        Text("\(items.count) NFT")
                            .font(.customFont(.caption2))
                            .foregroundColor(.textPrimary)

                        Text(String(format: "%.2f ETH", items.reduce(0) { $0 + $1.price }))
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

    // MARK: - Helpers
    private var sortedItems: [NFTItem] {
        switch sortOption {
        case .byPrice:
            return items.sorted { $0.price > $1.price }
        case .byRating:
            return items.sorted { $0.rating > $1.rating }
        case .byName:
            return items.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        }
    }

    private func deleteItem(_ item: NFTItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
            onDeleteRequest(item)
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

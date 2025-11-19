import SwiftUI
import Combine

// MARK: - CartView

struct CartView: View {
    @Binding var isSortMenuPresented: Bool
    @Binding var sortOption: CartSortOption
    let onDeleteRequest: (NFTItem) -> Void
    
    @StateObject private var viewModel = CartViewModel()
    @State private var isPaymentPresented = false
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            content
        }
        .background(Color.background.ignoresSafeArea())
        .onReceive(NotificationCenter.default.publisher(for: .deleteNFTItem)) { note in
            guard let item = note.object as? NFTItem else { return }
            withAnimation(.easeInOut) {
                viewModel.delete(item)
            }
        }
        .fullScreenCover(isPresented: $isPaymentPresented) {
            PaymentMethodView {
                viewModel.handlePaymentSuccess()
                isPaymentPresented = false
            }
        }
        .overlay(alignment: .bottom) {
            if case .loaded(let items) = viewModel.state {
                VStack(spacing: 0) {
                    cartSummary(items)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                }
                .frame(maxWidth: .infinity)
                .background(Color.segmentInactive)
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

// MARK: - Private Views

private extension CartView {
    
    // MARK: Navigation Bar
    var navigationBar: some View {
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
    }
    
    // MARK: Content by state
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Загрузка…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .empty:
            VStack {
                Spacer()
                Text("Корзина пуста")
                    .font(.customFont(.bodyBold))
                    .foregroundColor(.textPrimary)
                Spacer()
            }
            
        case .loaded(let items):
            cartContent(items)
            
        case .error(let message):
            VStack {
                Spacer()
                Text(message)
                    .foregroundColor(.red)
                    .padding()
                Spacer()
            }
        }
    }
    
    // MARK: Cart content
    func cartContent(_ items: [NFTItem]) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.sortedItems(items, by: sortOption)) { item in
                    CartCellView(item: item) {
                        onDeleteRequest(item)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.top, 4)
            .padding(.bottom, 120)
        }
    }
    
    // MARK: Summary block
    func cartSummary(_ items: [NFTItem]) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(items.count) NFT")
                    .font(.customFont(.caption2))
                    .foregroundColor(.textPrimary)
                
                let totalPrice = items.reduce(0) { $0 + $1.price }
                Text(String(format: "%.2f ETH", totalPrice))
                    .font(.customFont(.bodyBold))
                    .foregroundColor(.universalGreen)
            }
            
            Spacer()
            
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                    isPaymentPresented = true
                }
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
    }
}


// MARK: - Preview

#Preview("CartView") {
    CartView(
        isSortMenuPresented: .constant(false),
        sortOption: .constant(.byName),
        onDeleteRequest: { item in
            print("Удалено из превью: \(item.title)")
        }
    )
}

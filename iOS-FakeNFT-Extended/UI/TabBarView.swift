import SwiftUI

// MARK: - TabBarView

struct TabBarView: View {
    
    // MARK: - State
    @State private var isSortMenuPresented = false
    @State private var cartSort: CartSortOption = .byName
    @State private var deleteItem: NFTItem? = nil
    
    // MARK: - Init
    init() {
        TabBarConfigurator.setupAppearance()
    }
    
    // MARK: - Body
    var body: some View {
        TabView {
            // Профиль
            ProfileView()
                .tabItem { tabItem(icon: "profile", title: "Профиль") }
            
            // Каталог
CatalogView(
                    viewModel: CatalogViewModel(
                        catalogService: servicesAssembly.catalogService
                    )
                .tabItem { tabItem(icon: "catalog", title: "Каталог") }
            
            // Корзина
            CartView(
                isSortMenuPresented: $isSortMenuPresented,
                sortOption: $cartSort,
                onDeleteRequest: { item in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        deleteItem = item
                    }
                }
            )
            .tabItem { tabItem(icon: "cart", title: "Корзина") }
            
            // Статистика
            TestCatalogView()
                .tabItem { tabItem(icon: "statistic", title: "Статистика") }
        }
        .background(Color.background.ignoresSafeArea())
        .overlay(overlayContent)
    }
}

// MARK: - Subviews / Helpers

private extension TabBarView {
    
    // MARK: Tab item factory
    func tabItem(icon: String, title: String) -> some View {
        VStack(spacing: 2) {
            Image(icon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text(title)
        }
    }
    
    // MARK: Overlay content
    var overlayContent: some View {
        ZStack {
            // Меню сортировки
            if isSortMenuPresented {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isSortMenuPresented = false
                        }
                    }
                
                GeometryReader { geo in
                    VStack {
                        Spacer()
                        CartSortMenuView(
                            selectedOption: $cartSort,
                            isPresented: $isSortMenuPresented
                        )
                        .position(
                            x: geo.size.width / 2,
                            y: geo.size.height - 143
                        )
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(10)
            }
            
            // Окно удаления NFT
            if let item = deleteItem {
                DeleteFromCartView(
                    item: item,
                    onConfirm: {
                        withAnimation(.easeInOut) {
                            deleteItem = nil
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            NotificationCenter.default.post(
                                name: .deleteNFTItem,
                                object: item
                            )
                        }
                    },
                    onCancel: {
                        withAnimation(.easeInOut) {
                            deleteItem = nil
                        }
                    }
                )
                .transition(.opacity.combined(with: .scale))
                .zIndex(20)
            }
        }
        .background(Color.background.ignoresSafeArea())
    }
}

// MARK: - Reusable tab item

private struct TabBarItemView<Content: View>: View {
    let image: ImageResource
    let title: String
    let content: Content
    
    var body: some View {
        content
            .tabItem {
                VStack {
                    Image(image)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text(title)
                }
            }
    }
}

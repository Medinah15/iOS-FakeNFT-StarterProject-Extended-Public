import SwiftUI

struct TabBarView: View {
    @State private var isSortMenuPresented = false
    @State private var cartSort: CartView.SortOption = .byName
    @State private var deleteItem: NFTItem? = nil

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.background
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.1)

        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.textPrimary
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.textPrimary]

        appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isTranslucent = false
    }

    var body: some View {
        TabView {
            // === Профиль ===
            TestCatalogView()
                .tabItem {
                    VStack {
                        Image("profile")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Профиль")
                    }
                }

            // === Каталог ===
            TestCatalogView()
                .tabItem {
                    VStack {
                        Image("catalog")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Каталог")
                    }
                }

            // === Корзина ===
            CartView(
                isSortMenuPresented: $isSortMenuPresented,
                sortOption: $cartSort,
                onDeleteRequest: { item in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        deleteItem = item
                    }
                }
            )
            .tabItem {
                VStack {
                    Image("cart")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("Корзина")
                }
            }

            // === Статистика ===
            TestCatalogView()
                .tabItem {
                    VStack {
                        Image("statistic")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Статистика")
                    }
                }
        }
        .background(Color.background.ignoresSafeArea())

        // === Overlay на уровне всей TabView ===
        .overlay(
            ZStack {
                // Меню сортировки
                if isSortMenuPresented {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut) { isSortMenuPresented = false }
                        }

                    GeometryReader { geo in
                        VStack {
                            Spacer()
                            SortMenuView(
                                selectedOption: $cartSort,
                                isPresented: $isSortMenuPresented
                            )
                            .position(x: geo.size.width / 2, y: geo.size.height - 143)
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
                            withAnimation(.easeInOut) { deleteItem = nil }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                NotificationCenter.default.post(name: .deleteNFTItem, object: item)
                            }
                        },
                        onCancel: {
                            withAnimation(.easeInOut) { deleteItem = nil }
                        }
                    )
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(20)
                }
            }
        )
    }
}

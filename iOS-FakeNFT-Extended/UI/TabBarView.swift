import SwiftUI

struct TabBarView: View {
    @State private var isSortMenuPresented = false
    @State private var cartSort: CartView.SortOption = .byName

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
        ZStack {
            // Основной TabView
            TabView {
                // Профиль
                TestCatalogView()
                    .tabItem {
                        VStack {
                            Image("profile").renderingMode(.template).resizable().frame(width: 30, height: 30)
                            Text("Профиль")
                        }
                    }

                // Каталог
                TestCatalogView()
                    .tabItem {
                        VStack {
                            Image("catalog").renderingMode(.template).resizable().frame(width: 30, height: 30)
                            Text("Каталог")
                        }
                    }

                // Корзина — передаем биндинги
                CartView(isSortMenuPresented: $isSortMenuPresented, sortOption: $cartSort)
                    .tabItem {
                        VStack {
                            Image("cart").renderingMode(.template).resizable().frame(width: 30, height: 30)
                            Text("Корзина")
                        }
                    }

                // Статистика
                TestCatalogView()
                    .tabItem {
                        VStack {
                            Image("statistic").renderingMode(.template).resizable().frame(width: 30, height: 30)
                            Text("Статистика")
                        }
                    }
            }
            .background(Color.background.ignoresSafeArea())

            // === ВСПЛЫВАЮЩЕЕ МЕНЮ НА УРОВНЕ ВЫШЕ TAB BAR ===
            if isSortMenuPresented {
                // затемнение
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) { isSortMenuPresented = false }
                    }

                // само меню
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
                .animation(.easeInOut(duration: 0.25), value: isSortMenuPresented)
                .zIndex(10)
            }
        }
    }
}

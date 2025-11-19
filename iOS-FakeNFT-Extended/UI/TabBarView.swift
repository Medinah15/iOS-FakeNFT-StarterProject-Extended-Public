import SwiftUI

struct TabBarView: View {
    
    @Environment(ServicesAssembly.self) private var servicesAssembly
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.background
        appearance.shadowColor = .clear
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.textPrimary
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.textPrimary]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isTranslucent = true
    }
    
    var body: some View {
        TabView {
            TabBarItemView(
                image: .profile,
                title: "Профиль",
                content: TestCatalogView()
            )
            
            TabBarItemView(
                image: .catalog,
                title: "Каталог",
                content: CatalogView(
                    viewModel: CatalogViewModel(
                        catalogService: servicesAssembly.catalogService
                    )
                )
            )
            
            TabBarItemView(
                image: .cart,
                title: "Корзина",
                content: TestCatalogView()
            )
            
            TabBarItemView(
                image: .statistic,
                title: "Статистика",
                content: TestCatalogView()
            )
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

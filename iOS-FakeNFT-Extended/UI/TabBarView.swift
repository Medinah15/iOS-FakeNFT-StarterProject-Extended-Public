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
            
            CatalogView(
                viewModel: CatalogViewModel(
                    catalogService: servicesAssembly.catalogService
                )
            )
            .tabItem {
                VStack {
                    Image("catalog")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("Каталог")
                }
            }
            
            TestCatalogView()
                .tabItem {
                    VStack {
                        Image("cart")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Корзина")
                    }
                }
            
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
    }
}

import SwiftUI
@MainActor
final class StatisticViewModel: ObservableObject {
    @Published var usersAPI: [UserAPI] = []
    @Published var users: [UserStat] = []
    @Published var isLoading = false
    @Published var error: String?
    private let service: StatisticsService
    
    @Published var selectedSortOption: UserSortOption = .byName {
        didSet {
            applySorting()
        }
    }
    
    init(service: StatisticsService = StatisticsService()) {
        self.service = service
        Task { await loadUsers() }
    }
    
    func loadUsers() async {
        isLoading = true
        error = nil
        do {
            let fetchedUsers = try await service.fetchUsers()
            self.usersAPI = fetchedUsers
            applySorting()
        } catch {
            self.error = "Не удалось загрузить рейтинг: \(error.localizedDescription)"
            print("Ошибка загрузки пользователей: \(error)")
        }
        isLoading = false
    }
    
    private func applySorting() {
        var sortedUsersAPI: [UserAPI]
        
        switch selectedSortOption {
        case .byName:
            sortedUsersAPI = usersAPI.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .byNFTCount:
            sortedUsersAPI = usersAPI.sorted { $0.nfts.count > $1.nfts.count }
        }
        
        users = sortedUsersAPI.enumerated().map { index, userAPI in
            UserStat(userAPI: userAPI, index: index + 1)
        }
    }
}

private extension String {
    var intValue: Int { Int(self) ?? 0 }
}

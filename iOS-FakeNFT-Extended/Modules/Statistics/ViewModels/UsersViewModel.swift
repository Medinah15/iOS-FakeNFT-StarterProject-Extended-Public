import SwiftUI

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var users: [UserAPI] = []
    @Published var isLoading = false
    @Published var error: String?

    private let service: StatisticsService

    init(service: StatisticsService = StatisticsServiceImpl()) {
        self.service = service
        Task { await load() }
    }

    func load() async {
        isLoading = true
        do {
            users = try await service.fetchUsers()
        } catch {
            self.error = "Не удалось загрузить рейтинг"
        }
        isLoading = false
    }

    func sortedByRating() -> [UserAPI] {
        users.sorted { ($0.rating.intValue) < ($1.rating.intValue) }
    }
}

private extension String {
    var intValue: Int { Int(self) ?? 0 }
}

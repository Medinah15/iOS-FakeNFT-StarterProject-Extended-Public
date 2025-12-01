import SwiftUI
// MARK: - StatisticView
struct StatisticView: View {
    @StateObject private var viewModel = StatisticViewModel()
    @State private var isSortMenuPresented: Bool = false
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text("Ошибка: \(error)")
                        .foregroundColor(.red)
                } else if viewModel.users.isEmpty {
                    Text("Пользователи не найдены")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(viewModel.users) { user in
                            UsersListRow(user: user)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                    .background(Color.clear)
                }
            }
            .background(Color.clear)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isSortMenuPresented.toggle()
                    } label: {
                        Image("menu")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 42, height: 42)
                            .padding(.trailing, 9)
                            .foregroundColor(.textPrimary)
                    }
                }
            }
            .background(Color.background)
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .sheet(isPresented: $isSortMenuPresented) {
            UserSortMenuView(selectedOption: $viewModel.selectedSortOption, isPresented: $isSortMenuPresented)
                .presentationDetents([.height(getHeightForSortMenu(numOptions: UserSortOption.allCases.count))])
                .presentationBackground(.clear)
        }
        .onAppear {
            if viewModel.usersAPI.isEmpty && !viewModel.isLoading {
                Task { await viewModel.loadUsers() }
            }
        }
    }
    private func getHeightForSortMenu(numOptions: Int) -> CGFloat {
        return CGFloat(42 + (numOptions * 60) + (numOptions - 1) * 1 + 8 + 60 + 16)
    }
}

// MARK: - UsersListRow
struct UsersListRow: View {
    let user: UserStat
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(user.index)")
                .font(.customFont(.caption1))
                .foregroundColor(.textPrimary)
                .frame(width: 27, height: 20)
                .padding(.vertical, 30)
            
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: user.avatar)) { phase in
                    switch phase {
                    case .empty:
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 28, height: 28)
                    case .success(let img):
                        img.resizable()
                            .scaledToFill()
                            .frame(width: 28, height: 28)
                            .clipShape(Circle())
                    case .failure:
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                            )
                            .frame(width: 28, height: 28)
                    @unknown default:
                        EmptyView()
                    }
                }
                Text(user.name)
                    .font(.customFont(.headline3))
                    .foregroundColor(.textPrimary)
                Spacer()
                Text("\(user.nftsCount)")
                    .font(.customFont(.headline3))
                    .foregroundColor(.textPrimary)
            }
            .frame(height: 80)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.segmentInactive))
            )
            .contentShape(Rectangle())
        }
        .onTapGesture {
            print("Нажата ячейка пользователя: \(user.name)")
        }
    }
}
// MARK: - Preview
#Preview {
    StatisticView()
}

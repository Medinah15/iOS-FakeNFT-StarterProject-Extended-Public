import SwiftUI

struct UserStat: Identifiable {
    let id: String
    let index: Int
    let name: String
    let avatar: String
    let nftsCount: Int
}

struct UsersListView: View {

    @State private var users: [UserStat] = [
        .init(id: "1", index: 1, name: "Alex",
              avatar: "https://i.pravatar.cc/150?img=12", nftsCount: 112),
        .init(id: "2", index: 2, name: "Bill",
              avatar: "https://i.pravatar.cc/150?img=3", nftsCount: 98),
        .init(id: "3", index: 3, name: "Alla",
              avatar: "https://i.pravatar.cc/150?img=48", nftsCount: 72),
        .init(id: "4", index: 4, name: "Mads",
              avatar: "https://i.pravatar.cc/150?img=22", nftsCount: 71),
        .init(id: "5", index: 5, name: "Timothée",
              avatar: "https://i.pravatar.cc/150?img=13", nftsCount: 51),
        .init(id: "6", index: 6, name: "Lea",
              avatar: "https://i.pravatar.cc/150?img=7", nftsCount: 23),
        .init(id: "7", index: 7, name: "Eric",
              avatar: "https://i.pravatar.cc/150?img=32", nftsCount: 11)
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(users) { user in
                    UsersListRow(user: user)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Рейтинг")
        }
    }
}

struct UsersListRow: View {

    let user: UserStat

    var body: some View {
        HStack(spacing: 12) {

            // Место
            Text("\(user.index)")
                .font(.customFont(.bodyRegular))
                .foregroundColor(.textPrimary)
                .frame(width: 24, alignment: .leading)

            // Аватар
            AsyncImage(url: URL(string: user.avatar)) { phase in
                switch phase {
                case .empty:
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 44, height: 44)
                case .success(let img):
                    img.resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                case .failure:
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                        )
                        .frame(width: 44, height: 44)
                @unknown default:
                    EmptyView()
                }
            }

            // Имя
            Text(user.name)
                .font(.customFont(.headline2))
                .foregroundColor(.textPrimary)

            Spacer()

            // Кол-во NFT
            Text("\(user.nftsCount)")
                .font(.customFont(.headline2))
                .foregroundColor(.textPrimary)
        }
        .padding(.horizontal, 20)
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.segmentInactive))
        )
        .contentShape(Rectangle())
        .onTapGesture {
            // навигация в профиль (добавим позже)
        }
    }
}

#Preview {
    UsersListView()
}

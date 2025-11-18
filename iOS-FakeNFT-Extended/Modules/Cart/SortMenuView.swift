import SwiftUI

struct SortMenuView: View {
    @Binding var selectedOption: SortOption
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 8) {
            // MARK: - Блок сортировки
            VStack(spacing: 0) {
                // Заголовок
                Text("Сортировка")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color.black.opacity(0.6))
                    .frame(height: 42)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(16, corners: [.topLeft, .topRight])

                Divider()

                // Пункты меню
                ForEach(Array(SortOption.allCases.enumerated()), id: \.offset) { index, option in
                    Button {
                        selectedOption = option
                        isPresented = false
                    } label: {
                        Text(option.rawValue)
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.gray.opacity(0.1))
                    }

                    if index < SortOption.allCases.count - 1 {
                        Divider()
                            .background(Color.gray.opacity(0.3))
                            .padding(.horizontal, 16)
                    }
                }
            }
            .frame(height: 222)
            .background(Color.actionSheet)
            .cornerRadius(16)
            .padding(.horizontal, 20)

            // MARK: - Кнопка "Закрыть"
            Button {
                isPresented = false
            } label: {
                Text("Закрыть")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 16)
        .background(Color.clear.ignoresSafeArea())
    }
}

// MARK: - Corner Radius Helper
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 0
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview("SortMenuView") {
    SortMenuView(selectedOption: .constant(.byPrice), isPresented: .constant(true))
}

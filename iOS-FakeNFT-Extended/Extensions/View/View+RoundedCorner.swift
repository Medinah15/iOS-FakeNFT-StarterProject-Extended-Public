import SwiftUI

// MARK: - Расширение для View
// Позволяет скруглять только нужные углы, а не все сразу.
// Используется как .cornerRadius(16, corners: [.topLeft, .topRight])
extension View {

    /// Скругляет только указанные углы View.
    /// - Parameters:
    ///   - radius: радиус скругления
    ///   - corners: какие углы скруглять (например [.topLeft, .topRight])
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


// MARK: - Кастомная форма RoundedCorner
// UIBezierPath позволяет выбрать, какие углы скруглять.
// Затем эта форма используется как clipShape в модификаторе выше.
struct RoundedCorner: Shape {

    /// Радиус скругления углов
    var radius: CGFloat = 0

    /// Углы, которые нужно скруглить (например .topLeft, .bottomRight)
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        // Создаём скруглённый путь только для нужных углов
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


import SwiftUI

// MARK: - ViewModifier для закруглённого фона сверху
// Создаёт фон с закруглёнными верхними углами.
// Используется как:
//     .topRoundedBackground(radius: 16, color: .white)
struct TopRoundedBackground: ViewModifier {

    /// Радиус скругления верхних углов
    let radius: CGFloat

    /// Цвет фона
    let color: Color

    func body(content: Content) -> some View {
        content
            .background(
                TopRoundedCorner(radius: radius, corners: [.topLeft, .topRight])
                    .fill(color)
            )
    }
}


// MARK: - Форма для скругления только выбранных углов фона
// Аналогично RoundedCorner, но используется отдельно для background().
struct TopRoundedCorner: Shape {

    /// Радиус скругления
    var radius: CGFloat = .infinity

    /// Углы, которые нужно скруглить (обычно верхние)
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


// MARK: - Удобный модификатор View
// Позволяет легко использовать скруглённый верхний фон.
extension View {

    /// Добавляет фоновый цвет со скруглением только верхних углов.
    /// - Parameters:
    ///   - radius: радиус скругления
    ///   - color: цвет фона
    func topRoundedBackground(radius: CGFloat = 12, color: Color) -> some View {
        modifier(TopRoundedBackground(radius: radius, color: color))
    }
}

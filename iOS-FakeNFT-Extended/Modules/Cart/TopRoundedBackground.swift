import SwiftUI

struct TopRoundedBackground: ViewModifier {
    let radius: CGFloat
    let color: Color

    func body(content: Content) -> some View {
        content
            .background(
                TopRoundedCorner(radius: radius, corners: [.topLeft, .topRight])
                    .fill(color)
            )
    }
}

struct TopRoundedCorner: Shape {
    var radius: CGFloat = .infinity
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

extension View {
    func topRoundedBackground(radius: CGFloat = 12, color: Color) -> some View {
        modifier(TopRoundedBackground(radius: radius, color: color))
    }
}

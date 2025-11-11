import SwiftUI

extension Color {
    // Мостик: конвертация UIColor → Color
    init(_ uiColor: UIColor) {
        self.init(uiColor: uiColor)
    }

    // MARK: - Цвета из UIColor
    static let primary = Color(UIColor.primary)
    static let secondary = Color(UIColor.secondary)
    static let background = Color(UIColor.background)

    static let textPrimary = Color(UIColor.textPrimary)
    static let textSecondary = Color(UIColor.textSecondary)
    static let textOnPrimary = Color(UIColor.textOnPrimary)
    static let textOnSecondary = Color(UIColor.textOnSecondary)

    static let segmentActive = Color(UIColor.segmentActive)
    static let segmentInactive = Color(UIColor.segmentInactive)
    static let closeButton = Color(UIColor.closeButton)
    static let priceGreen = Color(UIColor.universalGreen)
    static let actionSheet = Color(UIColor.actionSheetGray)
}

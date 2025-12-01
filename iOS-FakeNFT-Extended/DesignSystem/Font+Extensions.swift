import SwiftUI

extension Font {
    /// Позволяет использовать UIFont в SwiftUI
    static func customFont(_ uiFont: UIFont) -> Font {
        Font(uiFont as CTFont)
    }
}

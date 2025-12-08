import SwiftUI

extension Font {
    
    static func customFont(_ uiFont: UIFont) -> Font {
        Font(uiFont as CTFont)
    }
}

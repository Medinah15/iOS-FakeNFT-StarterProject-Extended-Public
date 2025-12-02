import UIKit

extension UIColor {
    
    // MARK: - Init from HEX
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3:
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }
    
    // MARK: - Base palette
    private static let yaBlackLight = UIColor(hexString: "#1A1B22")
    private static let yaBlackDark = UIColor.white
    private static let yaLightGrayLight = UIColor(hexString: "#F7F7F8")
    private static let yaLightGrayDark = UIColor(hexString: "#2C2C2E")
    
    // MARK: - Primary & Secondary
    static let primary = UIColor { traits in
        traits.userInterfaceStyle == .dark
        ? UIColor(hexString: "#0A84FF")
        : UIColor(hexString: "#007AFF")
    }
    
    static let secondary = UIColor { traits in
        traits.userInterfaceStyle == .dark
        ? UIColor(hexString: "#30D158")
        : UIColor(hexString: "#34C759")
    }
    
    // MARK: - Background
    static let background = UIColor { traits in
        traits.userInterfaceStyle == .dark ? .yaBlackLight : universalWhite
    }
    
    // MARK: - Text
    static let textPrimary = UIColor { traits in
        traits.userInterfaceStyle == .dark ? universalWhite : .yaBlackLight
    }
    
    static let textButton = UIColor { traits in
        traits.userInterfaceStyle == .dark ? .black : .white
    }
    
    static let textSecondary = UIColor { traits in
        traits.userInterfaceStyle == .dark ? .lightGray : .gray
    }
    
    static let textOnPrimary = UIColor.white
    static let textOnSecondary = UIColor.black
    
    // MARK: - Segments
    static let segmentActive = UIColor { traits in
        traits.userInterfaceStyle == .dark ? .yaBlackLight : .yaBlackLight
    }
    
    static let segmentInactive = UIColor { traits in
        traits.userInterfaceStyle == .dark ? .yaLightGrayDark : .yaLightGrayLight
    }
    
    // MARK: - Accent / Buttons
    static let universalYellow = UIColor(hexString: "#FEEF0D")
    static let universalWhite = UIColor(hexString: "#FFFFFF")
    static let universalRed = UIColor(hexString: "#F56B6C")
    static let universalGreen = UIColor(hexString: "#1C9F00")
    static let actionSheetGray = UIColor(hexString: "#F5F5F5")
    static let priceGreen = UIColor(hexString: "#32D74B")
    static let closeButton = UIColor { traits in
        traits.userInterfaceStyle == .dark ? .yaBlackDark : .yaBlackLight
    }
}

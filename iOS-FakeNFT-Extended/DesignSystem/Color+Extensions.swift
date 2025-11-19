//
//  Color+Extensions.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 17.11.25.
//

import SwiftUI

extension Color {
    // MARK: - Init bridge
    init(_ uiColor: UIColor) {
        self.init(uiColor: uiColor)
    }
    
    // MARK: - Основная палитра
    static let primary = Color(UIColor.primary)
    static let secondary = Color(UIColor.secondary)
    
    // MARK: - Фон
    static let background = Color(UIColor.background)
    
    // MARK: - Текст
    static let textPrimary = Color(UIColor.textPrimary)
    static let textButton = Color(UIColor.textButton)
    static let textSecondary = Color(UIColor.textSecondary)
    static let textOnPrimary = Color(UIColor.textOnPrimary)
    static let textOnSecondary = Color(UIColor.textOnSecondary)
    
    // MARK: - Сегменты и кнопки
    static let segmentActive = Color(UIColor.segmentActive)
    static let segmentInactive = Color(UIColor.segmentInactive)
    static let closeButton = Color(UIColor.closeButton)
    static let priceGreen = Color(UIColor.priceGreen)
    static let actionSheet = Color(UIColor.actionSheetGray)
}

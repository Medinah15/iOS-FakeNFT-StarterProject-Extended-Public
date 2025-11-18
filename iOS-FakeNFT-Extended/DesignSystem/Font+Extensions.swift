//
//  Font+Extensions.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 17.11.25.
//

import SwiftUI

extension Font {
    static func customFont(_ uiFont: UIFont) -> Font {
        Font(uiFont as CTFont)
    }
}

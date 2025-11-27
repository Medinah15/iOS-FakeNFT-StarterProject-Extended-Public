//
//  NFTResponse.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 27.11.2025.
//

import Foundation


struct NFTResponse: Decodable {
    let id: String
    let name: String
    let images: [String]  // Массив URL изображений
    let rating: Int
    let price: Double
    let author: String   // Возможно в отдельном запросе или вложенном объекте
}

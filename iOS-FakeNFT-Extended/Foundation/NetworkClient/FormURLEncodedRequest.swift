//
//  FormURLEncodedRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 27.11.2025.
//

import Foundation

protocol FormURLEncodedRequest: NetworkRequest {
    var formParameters: [String: String] { get }
}

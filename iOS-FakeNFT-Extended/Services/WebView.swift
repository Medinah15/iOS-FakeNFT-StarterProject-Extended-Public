//
//  WebView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 29.11.25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let web = WKWebView()
        if let url = URL(string: "https://practicum.yandex.ru/ios-developer/") {
            let request = URLRequest(url: url)
            web.load(request)
        }
        return web
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

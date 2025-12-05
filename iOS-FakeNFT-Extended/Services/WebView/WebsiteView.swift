//
//  WebsiteView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 17.11.2025.
//

import SwiftUI

struct WebsiteView: View {
    let urlString: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if let url = URL(string: urlString) {
            WebView(url: url)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.primary)
                        }
                    }
                }
        } else {
            VStack {
                Text("Некорректный адрес сайта")
                    .foregroundColor(.primary)
                    .padding()

                Button("Назад") {
                    dismiss()
                }
            }
        }
    }
}

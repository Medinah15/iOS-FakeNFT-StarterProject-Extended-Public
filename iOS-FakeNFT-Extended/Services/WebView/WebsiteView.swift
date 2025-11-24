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
        WebView(url: URL(string: urlString)!)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
    }
}

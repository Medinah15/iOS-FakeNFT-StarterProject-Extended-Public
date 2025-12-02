//
//  WebViewScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Medina Huseynova on 29.11.25.
//
import SwiftUI
import WebKit

struct WebViewScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WebView()
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar) 
            .toolbar {
                
                ToolbarItem(placement: .bottomBar) {
                    EmptyView()
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("backward")
                            .foregroundColor(.textPrimary)
                    }
                }
            }
    }
}

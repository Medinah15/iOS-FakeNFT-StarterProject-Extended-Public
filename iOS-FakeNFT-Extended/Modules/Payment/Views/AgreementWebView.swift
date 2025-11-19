import SwiftUI
import WebKit

struct AgreementWebView: UIViewRepresentable {
    let url: URL
    let onLoadFinished: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onLoadFinished: onLoadFinished)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
    
    final class Coordinator: NSObject, WKNavigationDelegate {
        private let onLoadFinished: () -> Void
        
        init(onLoadFinished: @escaping () -> Void) {
            self.onLoadFinished = onLoadFinished
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            onLoadFinished()
        }
    }
}

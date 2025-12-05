import SwiftUI

struct AgreementView: View {
    let url: URL
    
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            AgreementWebView(
                url: url,
                onLoadFinished: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        isLoading = false
                    }
                }
            )
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.4)
                    .transition(.opacity)
            }
        }
    }
}

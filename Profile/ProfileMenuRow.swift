//
//  ProfileMenuRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 17.11.2025.
//

import SwiftUI

struct ProfileMenuRow: View {
    let item: ProfileMenuItem
    
    var body: some View {
        Button(action: item.action) {
            HStack(spacing: 12) {
                Text(item.displayTitle)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(UIColor.textPrimary))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(UIColor.textPrimary))
                    .font(.system(size: 14, weight: .regular))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
#Preview {
    VStack {
        ProfileMenuRow(item: .myNFTs)
        ProfileMenuRow(item: .favorites)
    }
}

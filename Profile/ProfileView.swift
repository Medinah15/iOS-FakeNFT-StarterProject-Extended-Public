//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 17.11.2025.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @State private var showWebsite = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Аватар и имя
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: viewModel.profile.avatar)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        
                        Text(viewModel.profile.name)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    
                    // Описание
                    Text(viewModel.profile.description)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.primary)
                        .lineSpacing(5)
                        .lineLimit(4)
                        .padding(.horizontal, 16)
                    
                    // Кнопка сайта
                    Button(action: {
                        showWebsite = true
                    }) {
                        HStack {
                            Text(viewModel.profile.website)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.blue)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .navigationDestination(isPresented: $showWebsite) {
                        WebsiteView(urlString: "https://practicum.yandex.ru/ios-developer/")
                    }
                    
                    // Меню
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.menuItems) { item in
                            ProfileMenuRow(item: item)
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Редактировать профиль")
                    }) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

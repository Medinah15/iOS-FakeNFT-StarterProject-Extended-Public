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
    @State private var showEditProfile = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Аватар и имя
                    avatarAndNameSection
                        .padding(.top, 20)
                    
                    // Описание
                    descriptionSection
                    
                    // Кнопка сайта
                    websiteButton
                    
                    // Меню
                    menuSection
                }
                .padding(.horizontal, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    editButton
                }
            }
        }
    }
    
    // MARK: - Avatar and Name Section
    private var avatarAndNameSection: some View {
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
    }
    
    // MARK: - Description Section
    private var descriptionSection: some View {
        Text(viewModel.profile.description)
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(.primary)
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    // MARK: - Website Button
    private var websiteButton: some View {
        Button(action: {
            showWebsite = true
        }) {
            HStack {
                Text(viewModel.profile.website)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.blue)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .navigationDestination(isPresented: $showWebsite) {
            WebsiteView(urlString: "https://practicum.yandex.ru/ios-developer/")
        }
    }
    
    // MARK: - Menu Section
    private var menuSection: some View {
        LazyVStack(spacing: 0) {
            ForEach(viewModel.menuItems) { item in
                ProfileMenuRow(item: item)
            }
        }
        .padding(.top, 40)
    }
    
    // MARK: - Edit Button
    private var editButton: some View {
        Button(action: {
            showEditProfile = true
        }) {
            Image(systemName: "square.and.pencil")
                .foregroundColor(.primary)
        }
        .navigationDestination(isPresented: $showEditProfile) {
            EditProfileView(
                profile: viewModel.profile,
                onSave: { name, description, website, avatar in
                    viewModel.updateProfile(
                        name: name,
                        description: description,
                        website: website,
                        avatar: avatar
                    )
                }
            )
        }
    }
}

#Preview {
    ProfileView()
}

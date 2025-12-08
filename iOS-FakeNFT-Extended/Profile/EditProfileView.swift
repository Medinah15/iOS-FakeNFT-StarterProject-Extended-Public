//
//  EditProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 17.11.2025.
//

import SwiftUI
import UIKit

struct EditProfileView: View {
    @State private var name: String
    @State private var description: String
    @State private var website: String
    @State private var avatarURL: String
    @State private var showPhotoOptions = false
    @State private var showSaveAlert = false
    @State private var isSaving = false
    
    private let initialName: String
    private let initialDescription: String
    private let initialWebsite: String
    private let initialAvatarURL: String
    
    @Environment(\.dismiss) var dismiss
    
    var onSave: ((String, String, String, String) async -> Void)?
    
    init(profile: ProfileModel, onSave: ((String, String, String, String) async -> Void)? = nil) {
        _name = State(initialValue: profile.name)
        _description = State(initialValue: profile.description)
        _website = State(initialValue: profile.website)
        _avatarURL = State(initialValue: profile.avatar)
        
        initialName = profile.name
        initialDescription = profile.description
        initialWebsite = profile.website
        initialAvatarURL = profile.avatar
        
        self.onSave = onSave
    }
    
    private var hasChanges: Bool {
        name != initialName ||
        description != initialDescription ||
        website != initialWebsite ||
        avatarURL != initialAvatarURL
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 24) {
                       
                        avatarSection
                            .padding(.top, 20)
                        
                        nameField
                        
                        descriptionField
                       
                        websiteField
                        
                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(.horizontal, 16)
                }
                .background(Color(UIColor.systemGray6))
                
                if hasChanges {
                    saveButton
                }
            }
            .overlay(alignment: .center) {
                if isSaving {
                    ZStack {
                        Color(UIColor.yaLightGrayLight)
                            .frame(width: 82, height: 82)
                            .cornerRadius(12)
                        
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.gray)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        handleBackButton()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
            .confirmationDialog("Фото профиля", isPresented: $showPhotoOptions, titleVisibility: .visible) {
                Button("Изменить фото") {
                    showPhotoLinkAlert()
                }
                
                Button("Удалить фото", role: .destructive) {
                    deletePhoto()
                }
                
                Button("Отмена", role: .cancel) {}
            }
            .alert("Профиль сохранен", isPresented: $showSaveAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Изменения успешно сохранены")
            }
        }
    }
    
    // MARK: - Avatar Section
    private var avatarSection: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if let url = URL(string: avatarURL), !avatarURL.isEmpty {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                        @unknown default:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 70, height: 70)
            .clipShape(Circle())
            
            Button(action: {
                showPhotoOptions = true
            }) {
                Image(systemName: "camera.fill")
                    .foregroundColor(Color(UIColor.black))
                    .font(.system(size: 12))
                    .frame(width: 22, height: 22)
                    .background(Color(UIColor.yaLightGrayLight))
                    .clipShape(Circle())
            }
            .offset(x: -2, y: 1)
        }
    }
    
    // MARK: - Name Field
    private var nameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Имя")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            
            TextField("Введите имя", text: $name)
                .font(.system(size: 17, weight: .regular))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(UIColor.yaLightGrayLight))
                .cornerRadius(12)
        }
    }
    
    // MARK: - Description Field
    private var descriptionField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Описание")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            
            TextEditor(text: $description)
                .font(.system(size: 17, weight: .regular))
                .frame(height: 100)
                .padding(8)
                .background(Color(UIColor.yaLightGrayLight))
                .cornerRadius(12)
                .scrollContentBackground(.hidden)
        }
    }
    
    // MARK: - Website Field
    private var websiteField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Сайт")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            
            TextField("Введите сайт", text: $website)
                .font(.system(size: 17, weight: .regular))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(UIColor.yaLightGrayLight))
                .cornerRadius(12)
        }
    }
    
    // MARK: - Save Button
    private var saveButton: some View {
        Button(action: {
            saveProfile()
        }) {
            Text("Сохранить")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(UIColor.yaBlackLight))
                .cornerRadius(16)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    // MARK: - Actions
    private func saveProfile() {
        isSaving = true
        
        Task {
            await onSave?(name, description, website, avatarURL)
            isSaving = false
            showSaveAlert = true
        }
    }
    private func deletePhoto() {
        
        avatarURL = ""
    }
    
    private func handleBackButton() {
        if hasChanges {
            showExitConfirmationAlert()
        } else {
            dismiss()
        }
    }
    
    private func showExitConfirmationAlert() {
        let alert = UIAlertController(title: nil, message: "Уверены,\nчто хотите выйти?", preferredStyle: .alert)
        
   
        let stayAction = UIAlertAction(title: "Остаться", style: .default) { _ in

        }
        stayAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        alert.addAction(stayAction)
        
  
        let exitAction = UIAlertAction(title: "Выйти", style: .default) { _ in
            self.dismiss()
        }
        exitAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        
       
        alert.addAction(exitAction)
        
       
        alert.preferredAction = exitAction
        
        // Показываем alert
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            var topController = rootViewController
            while let presented = topController.presentedViewController {
                topController = presented
            }
            topController.present(alert, animated: true)
        }
    }
    
    private func showPhotoLinkAlert() {
        let alert = UIAlertController(title: "Ссылка на фото", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "http://www.example.com"
            textField.text = self.avatarURL
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let textField = alert.textFields?.first, let text = textField.text, !text.isEmpty {
                self.avatarURL = text
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            var topController = rootViewController
            while let presented = topController.presentedViewController {
                topController = presented
            }
            topController.present(alert, animated: true)
        }
    }
}


#Preview {
    EditProfileView(profile: ProfileModel.mock())
}

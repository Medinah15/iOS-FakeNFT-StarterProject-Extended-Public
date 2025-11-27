
//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дионисий Коневиченко on 17.11.2025.
//

import SwiftUI

struct ProfileView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @State private var viewModel: ProfileViewModel
    @State private var nftViewModel: NFTViewModel
    @State private var showWebsite = false
    @State private var showEditProfile = false
    @State private var showMyNFTs = false
    @State private var showFavorites = false
    @State private var networkClient: NetworkClient?
    
    init() {
        // Временная инициализация, будет перезаписана в onAppear
        let tempServices = ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl()
        )
        _viewModel = State(initialValue: ProfileViewModel(profileService: tempServices.profileService))
        // Временная инициализация с пустым массивом, будет перезаписана в onAppear
        _nftViewModel = State(initialValue: NFTViewModel(nfts: []))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                
                // Loader overlay
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    editButton
                }
            }
            .navigationDestination(isPresented: $showMyNFTs) {
                MyNFTListView(viewModel: nftViewModel)
            }
            .navigationDestination(isPresented: $showFavorites) {
                FavouritesNFTListView(allNFTsViewModel: nftViewModel)
            }
            .alert("Ошибка", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
            .onAppear {
                setupViewModels()
                setupMenuActions()
            }
        }
    }
    
    // MARK: - Setup ViewModels
    private func setupViewModels() {
        // Обновляем ViewModels с правильными сервисами из Environment
        let profileVM = ProfileViewModel(profileService: servicesAssembly.profileService)
        viewModel = profileVM
        
        // Создаем NFTViewModel с сервисами и ссылкой на ProfileViewModel
        let nftVM = NFTViewModel(
            nftService: servicesAssembly.nftService,
            profileService: servicesAssembly.profileService,
            profileViewModel: profileVM
        )
        nftViewModel = nftVM
        
        // Устанавливаем обратную ссылку для синхронизации NFT данных
        profileVM.nftViewModel = nftVM
        
        // Сохраняем NetworkClient для загрузки изображений
        networkClient = DefaultNetworkClient()
    }
    
    // MARK: - Setup Menu Actions
    private func setupMenuActions() {
        viewModel.setupMenuActions(
            onMyNFTsTap: {
                showMyNFTs = true
            },
            onFavoritesTap: {
                showFavorites = true
            }
        )
    }
    
    // MARK: - Avatar and Name Section
    private var avatarAndNameSection: some View {
        HStack(spacing: 16) {
            AvatarImageView(avatarURL: viewModel.profile.avatar, networkClient: networkClient)
            
            Text(viewModel.profile.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
    
    // MARK: - Avatar Image View
    private struct AvatarImageView: View {
        let avatarURL: String
        let networkClient: NetworkClient?
        @State private var loadedImage: UIImage?
        @State private var isLoading = true
        
        var body: some View {
            Group {
                if let image = loadedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if isLoading {
                    ProgressView()
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 70, height: 70)
            .clipShape(Circle())
            .task {
                await loadAvatarImage()
            }
        }
        
        // Загрузка изображения через NetworkClient (как и данные профиля)
        private func loadAvatarImage() async {
            guard !avatarURL.isEmpty, let url = URL(string: avatarURL) else {
                isLoading = false
                return
            }
            
            // Создаем простой NetworkRequest для загрузки изображения
            let imageRequest = ImageRequest(url: url)
            
            do {
                if let client = networkClient {
                    // Используем NetworkClient для загрузки (как и данные профиля)
                    let imageData = try await client.send(request: imageRequest)
                    
                    if let image = UIImage(data: imageData) {
                        await MainActor.run {
                            loadedImage = image
                            isLoading = false
                        }
                    } else {
                        isLoading = false
                    }
                } else {
                    // Fallback на обычный URLSession если NetworkClient недоступен
                    await loadWithURLSession(url: url)
                }
            } catch {
                // Fallback на обычный URLSession при ошибке
                await loadWithURLSession(url: url)
            }
        }
        
        // Fallback загрузка через URLSession
        private func loadWithURLSession(url: URL) async {
            var request = URLRequest(url: url)
            request.timeoutInterval = 10.0
            request.cachePolicy = .returnCacheDataElseLoad
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    await MainActor.run { isLoading = false }
                    return
                }
                
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        loadedImage = image
                        isLoading = false
                    }
                } else {
                    await MainActor.run { isLoading = false }
                }
            } catch {
                // Тихая ошибка - просто показываем placeholder
                await MainActor.run { isLoading = false }
            }
        }
    }
    
    // MARK: - Image Request для загрузки изображений
    private struct ImageRequest: NetworkRequest {
        let url: URL
        
        var endpoint: URL? {
            return url
        }
        
        var httpMethod: HttpMethod {
            return .get
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
                    Task {
                        await viewModel.updateProfile(
                            name: name,
                            description: description,
                            website: website,
                            avatar: avatar
                        )
                    }
                }
            )
        }
    }
}

#Preview {
    ProfileView()
        .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
}



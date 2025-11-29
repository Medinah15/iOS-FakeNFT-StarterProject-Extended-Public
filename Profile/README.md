# Profile Module - Документация

## 📋 Содержание

1. [Обзор модуля](#обзор-модуля)
2. [Архитектура](#архитектура)
3. [Структура файлов](#структура-файлов)
4. [Основные компоненты](#основные-компоненты)
5. [Реализованные функции](#реализованные-функции)
6. [Паттерны и подходы](#паттерны-и-подходы)

---

## 🎯 Обзор модуля

Модуль Profile реализует функционал профиля пользователя с возможностью:
- Просмотра и редактирования профиля
- Просмотра списка "Мои NFT" с сортировкой
- Просмотра и управления избранными NFT
- Сохранения данных между сессиями

---

## 🏗 Архитектура

Проект использует **MVVM (Model-View-ViewModel)** архитектуру с SwiftUI:

```
View (SwiftUI) 
    ↓
ViewModel (@Observable)
    ↓
Model (Codable)
    ↓
UserDefaults (Persistence)
```

### Ключевые принципы:

1. **Разделение ответственности**: View отвечает только за UI, ViewModel - за бизнес-логику
2. **Реактивность**: Использование `@Observable` для автоматического обновления UI
3. **Единый источник истины**: Один ViewModel для управления состоянием NFT
4. **Data Binding**: Использование `@Binding` для синхронизации состояния между компонентами

---

## 📁 Структура файлов

```
Profile/
├── ProfileView.swift              # Главный экран профиля
├── EditProfileView.swift          # Экран редактирования профиля
├── ProfileViewModel.swift         # ViewModel для профиля
├── ProfileModel.swift             # Модель данных профиля
├── ProfileMenuItem.swift          # Модель элемента меню
├── ProfileMenuRow.swift           # Компонент строки меню
│
├── MyNFT/
│   ├── MyNFTListView.swift        # Экран "Мои NFT"
│   ├── NFTListRow.swift           # Ячейка NFT для списка
│   ├── NFTViewModel.swift         # ViewModel для NFT
│   └── NFTModel.swift             # Модель данных NFT
│
└── FavouritesNFT/
    ├── FavouritesNFTListView.swift    # Экран "Избранные NFT"
    ├── FavouritesNFTListRow.swift     # Ячейка NFT для grid
    └── FavouritesNFTViewModel.swift   # ViewModel для избранных NFT
```

---

## 🧩 Основные компоненты

### 1. ProfileView

**Назначение**: Главный экран профиля с информацией о пользователе и меню навигации.

**Ключевые особенности**:
- Отображение аватара, имени, описания
- Кнопка сайта с навигацией в WebView
- Меню с переходами к "Мои NFT" и "Избранные NFT"
- Кнопка редактирования профиля

**Реализация**:
```swift
struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @State private var nftViewModel = NFTViewModel() // Общий ViewModel
    
    var body: some View {
        NavigationStack {
            // UI компоненты
        }
    }
}
```

**Навигация**:
- Использует `NavigationStack` с `.navigationDestination`
- Передает общий `NFTViewModel` в дочерние экраны для синхронизации

---

### 2. EditProfileView

**Назначение**: Экран редактирования профиля с полями ввода.

**Ключевые особенности**:
- Поля для имени, описания, сайта
- Редактирование аватара через системный action sheet
- Ввод ссылки на фото через UIAlertController
- Кнопка "Сохранить" появляется только при изменениях
- Кастомный alert при выходе с несохраненными изменениями
- Loader при сохранении

**Реализация**:
```swift
struct EditProfileView: View {
    @State private var name: String
    @State private var description: String
    // ...
    
    private var hasChanges: Bool {
        name != initialName || 
        description != initialDescription || 
        // ...
    }
}
```

**Особенности**:
- Отслеживание изменений через сравнение с начальными значениями
- Использование UIKit для кастомных алертов (UIAlertController)
- Скрытие TabBar через `.toolbar(.hidden, for: .tabBar)`

---

### 3. MyNFTListView

**Назначение**: Экран со списком NFT пользователя с возможностью сортировки.

**Ключевые особенности**:
- Отображение NFT в виде списка (List)
- Сортировка по цене, рейтингу, названию
- Переключение избранного через сердечко
- Сохранение порядка сортировки между сессиями
- Пустое состояние при отсутствии NFT

**Реализация**:
```swift
struct MyNFTListView: View {
    @State private var viewModel: NFTViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.sortedNFTs) { nft in
                NFTListRow(
                    nft: nft,
                    isFavorite: viewModel.bindingForFavorite(nftId: nft.id)
                )
            }
        }
    }
}
```

**Сортировка**:
- Тип сортировки хранится в ViewModel
- Сохраняется в UserDefaults
- Применяется автоматически при загрузке

---

### 4. FavouritesNFTListView

**Назначение**: Экран избранных NFT в виде grid layout.

**Ключевые особенности**:
- Отображение NFT в grid (2 колонки)
- Удаление из избранного через сердечко
- Автоматическое обновление при изменении в основном списке
- Пустое состояние при отсутствии избранных

**Реализация**:
```swift
struct FavouritesNFTListView: View {
    @State private var viewModel: FavouritesNFTViewModel
    @State private var allNFTsViewModel: NFTViewModel
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(viewModel.favoriteNFTs) { nft in
                FavouritesNFTListRow(
                    nft: nft,
                    isFavorite: allNFTsViewModel.bindingForFavorite(nftId: nft.id),
                    onToggleFavorite: {
                        viewModel.refresh()
                    }
                )
            }
        }
    }
}
```

**Синхронизация**:
- Использует общий `NFTViewModel` из `ProfileView`
- Автоматически обновляется через `.onChange(of: allNFTsViewModel.nfts)`

---

## ⚙️ Реализованные функции

### 1. Управление состоянием через @Observable

**Что это**: Новый способ реактивного программирования в SwiftUI (iOS 17+).

**Как работает**:
```swift
@Observable
class NFTViewModel {
    var nfts: [NFTModel] = []
    
    func toggleFavorite(for nftId: String) {
        // Изменение автоматически обновляет все View, использующие этот ViewModel
        nfts[index].isFavorite.toggle()
    }
}
```

**Преимущества**:
- Не нужно использовать `@Published` и `ObservableObject`
- Более простая синтаксис
- Автоматическое обновление UI

---

### 2. Data Binding для синхронизации состояния

**Проблема**: Нужно синхронизировать состояние избранного между экранами.

**Решение**: Использование `@Binding` через метод в ViewModel.

**Реализация**:
```swift
// В NFTViewModel
func bindingForFavorite(nftId: String) -> Binding<Bool> {
    Binding(
        get: {
            self.nfts.first(where: { $0.id == nftId })?.isFavorite ?? false
        },
        set: { newValue in
            // Обновляем NFT в массиве
            if let index = self.nfts.firstIndex(where: { $0.id == nftId }) {
                // Создаем обновленный NFT
                let updatedNFT = NFTModel(..., isFavorite: newValue)
                self.nfts[index] = updatedNFT
                self.saveNFTs()
            }
        }
    )
}

// В View
NFTListRow(
    nft: nft,
    isFavorite: viewModel.bindingForFavorite(nftId: nft.id)
)
```

**Как это работает**:
1. ViewModel создает Binding для конкретного NFT
2. View использует этот Binding
3. При изменении через Binding автоматически обновляется ViewModel
4. Все View, использующие этот ViewModel, обновляются автоматически

---

### 3. Сохранение данных в UserDefaults

**Модели должны быть Codable**:
```swift
struct NFTModel: Identifiable, Codable, Equatable {
    // Все свойства должны быть Codable
}

enum NFTType: Codable, Equatable {
    case mock
    case real
}
```

**Сохранение**:
```swift
static func save(_ nfts: [NFTModel]) {
    let realNFTs = nfts.filter { $0.type == .real }
    if let encoded = try? JSONEncoder().encode(realNFTs) {
        UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
    }
}
```

**Загрузка**:
```swift
static func load(type: NFTType) -> [NFTModel] {
    switch type {
    case .mock:
        return mockData
    case .real:
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let nfts = try? JSONDecoder().decode([NFTModel].self, from: data) else {
            return []
        }
        return nfts
    }
}
```

---

### 4. Разделение Mock и Real данных через Enum

**Проблема**: Нужно различать мок-данные и реальные данные.

**Решение**: Использование enum для типа данных.

**Реализация**:
```swift
enum NFTType: Codable, Equatable {
    case mock
    case real
}

struct NFTModel {
    let type: NFTType
    // ...
    
    private static let mockData: [NFTModel] = [
        NFTModel(type: .mock, ...),
        // ...
    ]
    
    static func load(type: NFTType) -> [NFTModel] {
        switch type {
        case .mock:
            return mockData
        case .real:
            // Загрузка из UserDefaults
        }
    }
}
```

**Преимущества**:
- Четкое разделение мок и реальных данных
- Мок-данные не сохраняются в UserDefaults
- Легко переключаться между мок и реальными данными

---

### 5. Grid Layout для избранных NFT

**Реализация**:
```swift
private let columns = [
    GridItem(.flexible(), spacing: 7),
    GridItem(.flexible(), spacing: 7)
]

LazyVGrid(columns: columns, spacing: 20) {
    ForEach(viewModel.favoriteNFTs) { nft in
        FavouritesNFTListRow(nft: nft)
    }
}
```

**Параметры**:
- `GridItem(.flexible())` - колонки равной ширины
- `spacing: 7` - расстояние между колонками
- `spacing: 20` - расстояние между строками

---

### 6. Сортировка с сохранением состояния

**Реализация**:
```swift
@Observable
class NFTViewModel {
    var selectedSortType: NFTSortType = .byRating
    
    var sortedNFTs: [NFTModel] {
        switch selectedSortType {
        case .byPrice:
            return nfts.sorted { $0.price > $1.price }
        case .byRating:
            return nfts.sorted { $0.rating > $1.rating }
        case .byName:
            return nfts.sorted { $0.name < $1.name }
        }
    }
    
    func sortNFTs() {
        saveSortType()  // Сохраняем тип сортировки
        nfts = sortedNFTs  // Применяем сортировку
        saveNFTs()  // Сохраняем отсортированный массив
    }
    
    private func loadSortType() {
        // Загружаем из UserDefaults
    }
    
    private func saveSortType() {
        // Сохраняем в UserDefaults
    }
}
```

**Как работает**:
1. Тип сортировки сохраняется в UserDefaults
2. При загрузке применяется сохраненная сортировка
3. При изменении сортировки обновляется массив и сохраняется

---

## 🎨 Паттерны и подходы

### 1. Computed Properties для организации кода

**Пример**:
```swift
struct ProfileView: View {
    // MARK: - Avatar and Name Section
    private var avatarAndNameSection: some View {
        HStack {
            // ...
        }
    }
    
    // MARK: - Description Section
    private var descriptionSection: some View {
        Text(viewModel.profile.description)
            // ...
    }
}
```

**Преимущества**:
- Код более читаемый
- Легче найти нужный компонент
- Можно переиспользовать компоненты

---

### 2. MARK комментарии для навигации

**Использование**:
```swift
// MARK: - Properties
// MARK: - Initialization
// MARK: - Public Methods
// MARK: - Private Methods
// MARK: - Actions
```

**Польза**: Быстрая навигация по коду в Xcode.

---

### 3. Preview для разработки

**Пример**:
```swift
#Preview("With NFTs") {
    MyNFTListView()
}

#Preview("Empty State") {
    struct EmptyStatePreview: View {
        @State private var viewModel = NFTViewModel(nfts: [], sortType: .byRating)
        // ...
    }
    return EmptyStatePreview()
}
```

**Преимущества**:
- Быстрая проверка UI без запуска приложения
- Тестирование разных состояний
- Документация компонентов

---

### 4. Обработка состояний загрузки

**Пример**:
```swift
@State private var isSaving = false

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
```

---

### 5. Условное отображение элементов

**Примеры**:
```swift
// Кнопка видна только при изменениях
if hasChanges {
    saveButton
}

// Заголовок скрыт при пустом списке
.navigationTitle(viewModel.sortedNFTs.isEmpty ? "" : "Мои NFT")

// Кнопка сортировки только при наличии NFT
if !viewModel.sortedNFTs.isEmpty {
    sortButton
}
```

---

## 🔄 Поток данных

### Обновление избранного:

```
1. Пользователь нажимает сердечко в NFTListRow
   ↓
2. Изменяется Binding (isFavorite)
   ↓
3. Обновляется NFTViewModel.nfts
   ↓
4. Автоматически обновляется FavouritesNFTViewModel (через onChange)
   ↓
5. UI обновляется на обоих экранах
```

### Сохранение профиля:

```
1. Пользователь редактирует профиль в EditProfileView
   ↓
2. Нажимает "Сохранить"
   ↓
3. Вызывается onSave callback
   ↓
4. ProfileViewModel.updateProfile()
   ↓
5. ProfileModel.save() → UserDefaults
   ↓
6. Обновляется ProfileView
```

---

## 📝 Важные моменты

### 1. Единый источник истины

**Принцип**: Один `NFTViewModel` управляет всеми NFT и их состоянием избранного.

**Реализация**: 
- Создается в `ProfileView`
- Передается в `MyNFTListView` и `FavouritesNFTListView`
- Обеспечивает синхронизацию между экранами

### 2. Иммутабельность моделей

**Принцип**: Модели данных (NFTModel, ProfileModel) - это структуры (value types).

**Реализация**:
```swift
// Вместо изменения существующего NFT
let updatedNFT = NFTModel(
    type: nft.type,
    id: nft.id,
    // ... все свойства
    isFavorite: !nft.isFavorite  // Новое значение
)
nfts[index] = updatedNFT  // Заменяем старый на новый
```

### 3. Обработка ошибок

**Текущая реализация**: Использует fallback на мок-данные при ошибках загрузки.

**Пример**:
```swift
if realNFTs.isEmpty {
    nfts = NFTModel.load(type: .mock)  // Fallback
} else {
    nfts = realNFTs
}
```

---

## 🚀 Что можно улучшить

1. **Обработка ошибок**: Добавить показ ошибок пользователю
2. **API интеграция**: Подключить реальные API вместо UserDefaults
3. **Кэширование**: Добавить кэширование изображений
4. **Анимации**: Добавить плавные анимации при изменении состояния
5. **Тестирование**: Добавить unit-тесты для ViewModel

---

## 📚 Полезные ресурсы

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [MVVM Pattern](https://www.swiftbysundell.com/articles/making-mvvm-and-swiftui-work-together/)
- [Data Binding in SwiftUI](https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-binding-property-wrapper)
- [@Observable Macro](https://www.swiftbysundell.com/articles/the-observable-macro-in-swift/)

---

## 💡 Советы для изучения

1. **Начните с простого**: Изучите `ProfileView` - самый простой экран
2. **Изучите Binding**: Поймите, как работает `bindingForFavorite`
3. **Проследите поток данных**: От нажатия кнопки до обновления UI
4. **Экспериментируйте**: Попробуйте изменить код и посмотрите результат
5. **Читайте код**: Комментарии и MARK секции помогут понять структуру

---

**Удачи в изучении! 🎓**


//
//  UserSortMenuView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Dmitrii Seitsman on 01.12.2025.
//


import SwiftUI

struct UserSortMenuView<SortOptionType: RawRepresentable & CaseIterable & Identifiable>: View where SortOptionType.RawValue == String {
    @Binding var selectedOption: SortOptionType
    @Binding var isPresented: Bool

    let allOptions: [SortOptionType]
    init(selectedOption: Binding<SortOptionType>, isPresented: Binding<Bool>) {
        _selectedOption = selectedOption
        _isPresented = isPresented
        self.allOptions = SortOptionType.allCases.map { $0 }
    }
    var body: some View {
        VStack(spacing: 8) {
            // MARK: - Блок сортировки
            VStack(spacing: 0) {
                // Заголовок
                Text("Сортировка")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color.black.opacity(0.6))
                    .frame(height: 42)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                Divider()
                // Пункты меню
                ForEach(allOptions.enumerated().map { $0 }, id: \.element.id) { index, option in
                    Button {
                        selectedOption = option
                        isPresented = false
                    } label: {
                        Text(option.rawValue)
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.gray.opacity(0.1))
                    }
                    if index < allOptions.count - 1 {
                        Divider()
                            .background(Color.gray.opacity(0.3))
                            .padding(.horizontal, 16)
                    }
                }
            }
            .frame(height: CGFloat(allOptions.count) * 60 + 42)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .padding(.horizontal, 20)
            // MARK: - Кнопка "Закрыть"
            Button {
                isPresented = false
            } label: {
                Text("Закрыть")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 16)
        .background(Color.clear.ignoresSafeArea())
    }
}

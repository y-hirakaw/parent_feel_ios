import SwiftUI

struct ActionSelectionView<T: ActionType>: View {
    @Binding var selectedActions: Set<T>
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewState = ActionSelectionViewState<T>()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 検索バー
                searchView
                
                // カテゴリセレクタ
                categorySelector
                
                // メインコンテンツ
                ZStack {
                    Color.gray.opacity(0.05)
                        .ignoresSafeArea()
                    
                    VStack {
                        if viewState.filteredActions().isEmpty {
                            emptyStateView
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 8) {
                                    ForEach(viewState.filteredActions(), id: \.self) { action in
                                        MultipleSelectionRow(action: action, isSelected: viewState.contains(action)) {
                                            viewState.toggle(action)
                                        }
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .shadow(color: .black.opacity(0.03), radius: 2, y: 1)
                                        .padding(.horizontal)
                                    }
                                }
                                .padding(.vertical)
                            }
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "行動を選択"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Text(String(localized: "キャンセル"))
                            .foregroundColor(.blue)
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        withAnimation {
                            selectedActions = viewState.selectedActions
                            dismiss()
                        }
                    }) {
                        Text(String(localized: "完了"))
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .onAppear {
            viewState.selectedActions = selectedActions
        }
    }
    
    // 検索バーのビュー
    private var searchView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(String(localized: "検索"), text: $viewState.searchText)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if !viewState.searchText.isEmpty {
                Button(action: {
                    viewState.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding()
    }
    
    // カテゴリセレクタのビュー
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ActionCategory.allCases) { category in
                    Button(action: {
                        withAnimation {
                            viewState.selectedCategory = category
                        }
                    }) {
                        Text(category.displayText)
                            .font(.subheadline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .fill(viewState.selectedCategory == category ? Color.blue : Color.gray.opacity(0.1))
                            )
                            .foregroundColor(viewState.selectedCategory == category ? .white : .primary)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }
    
    // 検索結果が空の場合のビュー
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text(String(localized: "結果がありません"))
                .font(.headline)
                .foregroundColor(.primary)
            
            if !viewState.searchText.isEmpty {
                Text(String(localized: "「\(viewState.searchText)」に一致する行動は見つかりませんでした。\n別のキーワードで検索してください。"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            } else if viewState.selectedCategory == .recent && viewState.recentActions.isEmpty {
                Text(String(localized: "最近使用した行動はまだありません。\n行動を選択すると、ここに表示されます。"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.05))
    }
}

#Preview {
    ActionSelectionView(selectedActions: .constant(Set<ChildActionType>()))
}

import SwiftUI

struct ActionSelectionView<T: ActionType>: View {
    @Binding var selectedActions: Set<T>
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewState = ActionSelectionViewState<T>()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.05)
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(Array(T.allCases), id: \.self) { action in
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
            .navigationTitle("行動を選択")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Text("キャンセル")
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
                        Text("完了")
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
}

#Preview {
    ActionSelectionView(selectedActions: .constant(Set<ChildActionType>()))
}

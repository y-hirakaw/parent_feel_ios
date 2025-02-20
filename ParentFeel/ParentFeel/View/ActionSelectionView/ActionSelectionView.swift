import SwiftUI

struct ActionSelectionView<T: ActionType>: View {
    @Binding var selectedActions: Set<T>
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewState = ActionSelectionViewState<T>()

    var body: some View {
        NavigationView {
            List(Array(T.allCases), id: \.self) { action in
                MultipleSelectionRow(action: action, isSelected: viewState.contains(action)) {
                    viewState.toggle(action)
                }
            }
            .navigationTitle("行動を選択")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("OK") {
                        selectedActions = viewState.selectedActions
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            viewState.selectedActions = selectedActions
        }
    }
}

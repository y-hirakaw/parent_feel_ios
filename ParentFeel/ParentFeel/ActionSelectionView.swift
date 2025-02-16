import SwiftUI

struct ActionSelectionView<T: ActionType>: View {
    @Binding var selectedActions: Set<T>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List(Array(T.allCases), id: \.self) { action in
                MultipleSelectionRow(action: action, isSelected: selectedActions.contains(action)) {
                    if selectedActions.contains(action) {
                        selectedActions.remove(action)
                    } else {
                        selectedActions.insert(action)
                    }
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
                        dismiss()
                    }
                }
            }
        }
    }
}

struct MultipleSelectionRow<T: ActionType>: View {
    var action: T
    var isSelected: Bool
    var actionTapped: () -> Void

    var body: some View {
        Button(action: actionTapped) {
            HStack {
                Text(action.displayText)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

import SwiftUI

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

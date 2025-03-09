import SwiftUI

struct MultipleSelectionRow<T: ActionType>: View {
    var action: T
    var isSelected: Bool
    var actionTapped: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                actionTapped()
            }
        }) {
            HStack(spacing: 16) {
                Text(action.displayText)
                    .font(.body)
                    .foregroundColor(isSelected ? .blue : .primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                        .symbolEffect(.bounce, value: isSelected)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.gray.opacity(0.5))
                        .font(.system(size: 20))
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

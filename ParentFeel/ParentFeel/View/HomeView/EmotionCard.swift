import SwiftUI
import SwiftData

struct EmotionCard: View {
    @StateObject private var viewState: EmotionCardViewState
    
    init(emotion: Emotion) {
        _viewState = StateObject(wrappedValue: EmotionCardViewState(emotion: emotion))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Text(viewState.emotion.emotionType.emoji)
                    .font(.system(size: 40))
                    .padding(8)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.8))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewState.emotion.emotionType.displayText)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(viewState.getCategory(for: viewState.emotion.emotionType).displayText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(viewState.formattedDate(viewState.emotion.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(viewState.formattedTime(viewState.emotion.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if !viewState.emotion.notes.isEmpty {
                Text(viewState.emotion.notes)
                    .font(.body)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(viewState.backgroundColor(for: viewState.emotion.emotionType))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .scaleEffect(viewState.isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3), value: viewState.isPressed)
        .onLongPressGesture(minimumDuration: 0.5, pressing: { pressing in
            viewState.updatePressState(pressing)
        }) {
            // 長押し完了時のアクション
        }
    }
}
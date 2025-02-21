import Foundation
import Combine

@MainActor
class EmotionDetailViewState: ObservableObject {
    @Published var emotion: Emotion

    init(emotion: Emotion) {
        self.emotion = emotion
    }

    var emotionTypeText: String {
        "\(emotion.emotionType.emoji) \(emotion.emotionType.displayText)"
    }

    var childActionsText: String {
        emotion.childActions.map { $0.displayText }.joined(separator: ", ")
    }

    var parentActionsText: String {
        emotion.parentActions.map { $0.displayText }.joined(separator: ", ")
    }

    var notesText: String {
        emotion.notes
    }

    var timestampText: String {
        emotion.timestamp.formatted(date: .numeric, time: .shortened)
    }
}

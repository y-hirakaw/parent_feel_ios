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

    var pastExperienceText: String {
        emotion.pastExperience
    }

    var pastExperienceFeelingText: String {
        emotion.pastExperienceFeeling
    }

    var pastExperienceSentimentText: String {
        switch emotion.pastExperienceSentiment {
        case "positive":
            return String(localized: "ポジティブ")
        case "negative":
            return String(localized: "ネガティブ")
        default:
            return ""
        }
    }

    var desiredResponseText: String {
        emotion.desiredResponse
    }

    var notesText: String {
        emotion.notes
    }

    var timestampText: String {
        emotion.timestamp.formatted(date: .numeric, time: .shortened)
    }
}

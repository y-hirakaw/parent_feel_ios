import SwiftData
import Foundation

@Model
final class Emotion: Identifiable {
    var id: UUID
    var emotionType: EmotionType
    var childActions: [ChildActionType]
    var parentActions: [ParentActionType]
    var notes: String
    var timestamp: Date

    init(emotionType: EmotionType, childActions: [ChildActionType], parentActions: [ParentActionType], notes: String) {
        self.id = UUID()
        self.emotionType = emotionType
        self.childActions = childActions
        self.parentActions = parentActions
        self.notes = notes
        self.timestamp = Date()
    }
}

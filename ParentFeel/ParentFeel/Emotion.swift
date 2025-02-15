import SwiftData
import Foundation

@Model
final class Emotion: Identifiable {
    var id: UUID
    var emotionType: String
    var childActions: [String]
    var parentActions: [String]
    var notes: String
    var timestamp: Date

    init(emotionType: String, childActions: [String], parentActions: [String], notes: String) {
        self.id = UUID()
        self.emotionType = emotionType
        self.childActions = childActions
        self.parentActions = parentActions
        self.notes = notes
        self.timestamp = Date()
    }
}
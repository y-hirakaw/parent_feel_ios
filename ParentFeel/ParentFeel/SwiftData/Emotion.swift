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
    var pastExperience: String = ""
    var pastExperienceFeeling: String = ""
    var pastExperienceSentiment: String = "" // "positive", "negative", or empty
    var desiredResponse: String = ""

    init(emotionType: EmotionType, childActions: [ChildActionType], parentActions: [ParentActionType], notes: String, 
         pastExperience: String = "", pastExperienceFeeling: String = "", pastExperienceSentiment: String = "", desiredResponse: String = "") {
        self.id = UUID()
        self.emotionType = emotionType
        self.childActions = childActions
        self.parentActions = parentActions
        self.notes = notes
        self.timestamp = Date()
        self.pastExperience = pastExperience
        self.pastExperienceFeeling = pastExperienceFeeling
        self.pastExperienceSentiment = pastExperienceSentiment
        self.desiredResponse = desiredResponse
    }
}

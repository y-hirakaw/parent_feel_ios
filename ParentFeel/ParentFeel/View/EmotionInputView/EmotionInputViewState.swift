import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
class EmotionInputViewState: ObservableObject {
    @Published var selectedEmotion: EmotionType
    @Published var selectedChildActions: Set<ChildActionType>
    @Published var selectedParentActions: Set<ParentActionType>
    @Published var notes: String
    @Published var isChildActionModalPresented = false
    @Published var isParentActionModalPresented = false
    
    // New properties for self-reflection
    @Published var pastExperience: String
    @Published var pastExperienceFeeling: String
    @Published var pastExperienceSentiment: String // "positive", "negative", or empty
    @Published var desiredResponse: String
    
    private var modelContext: ModelContext?
    @Binding var path: NavigationPath
    private var emotion: Emotion?
    
    init(emotion: Emotion? = nil, path: Binding<NavigationPath>) {
        self._path = path
        if let emotion = emotion {
            self.selectedEmotion = emotion.emotionType
            self.selectedChildActions = Set(emotion.childActions)
            self.selectedParentActions = Set(emotion.parentActions)
            self.notes = emotion.notes
            self.emotion = emotion
            
            // Initialize new properties with existing values if editing
            self.pastExperience = emotion.pastExperience
            self.pastExperienceFeeling = emotion.pastExperienceFeeling
            self.pastExperienceSentiment = emotion.pastExperienceSentiment
            self.desiredResponse = emotion.desiredResponse
        } else {
            self.selectedEmotion = .affection
            self.selectedChildActions = []
            self.selectedParentActions = []
            self.notes = ""
            
            // Initialize new properties as empty if creating new
            self.pastExperience = ""
            self.pastExperienceFeeling = ""
            self.pastExperienceSentiment = ""
            self.desiredResponse = ""
        }
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func saveEmotion() {
        if let emotion = emotion {
            emotion.emotionType = selectedEmotion
            emotion.childActions = selectedChildActions.compactMap { ChildActionType(rawValue: $0.rawValue) }
            emotion.parentActions = selectedParentActions.compactMap { ParentActionType(rawValue: $0.rawValue) }
            emotion.notes = notes
            
            // Update new fields
            emotion.pastExperience = pastExperience
            emotion.pastExperienceFeeling = pastExperienceFeeling
            emotion.pastExperienceSentiment = pastExperienceSentiment
            emotion.desiredResponse = desiredResponse
            
            try? modelContext?.save()
        } else {
            let newEmotion = Emotion(
                emotionType: selectedEmotion,
                childActions: selectedChildActions.compactMap { ChildActionType(rawValue: $0.rawValue) },
                parentActions: selectedParentActions.compactMap { ParentActionType(rawValue: $0.rawValue) },
                notes: notes,
                pastExperience: pastExperience,
                pastExperienceFeeling: pastExperienceFeeling,
                pastExperienceSentiment: pastExperienceSentiment,
                desiredResponse: desiredResponse
            )
            modelContext?.insert(newEmotion)
        }
        path.removeLast()
    }
}

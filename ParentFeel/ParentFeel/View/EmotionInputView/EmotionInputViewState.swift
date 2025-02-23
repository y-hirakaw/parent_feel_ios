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
        } else {
            self.selectedEmotion = .affection
            self.selectedChildActions = []
            self.selectedParentActions = []
            self.notes = ""
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
            try? modelContext?.save()
        } else {
            let newEmotion = Emotion(
                emotionType: selectedEmotion,
                childActions: selectedChildActions.compactMap { ChildActionType(rawValue: $0.rawValue) },
                parentActions: selectedParentActions.compactMap { ParentActionType(rawValue: $0.rawValue) },
                notes: notes
            )
            modelContext?.insert(newEmotion)
        }
        path.removeLast()
    }
}

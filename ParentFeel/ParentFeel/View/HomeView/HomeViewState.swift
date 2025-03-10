import SwiftUI
import SwiftData

class HomeViewState: ObservableObject {
    @Published var path = NavigationPath()
    @Published var isEditing = false
    @Published var selectedTab = 0
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func updateModelContext(_ newContext: ModelContext) {
        self.modelContext = newContext
    }
    
    func deleteEmotions(emotions: [Emotion], offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(emotions[index])
            }
        }
    }
    
    func deleteEmotion(emotion: Emotion) {
        withAnimation {
            modelContext.delete(emotion)
        }
    }
}

import SwiftUI
import SwiftData
import Combine

@MainActor
class HomeViewState: ObservableObject {
    @Published var emotions: [Emotion] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        fetchEmotions()
    }
    
    func fetchEmotions() {
        guard let modelContext = modelContext else { return }
        
        isLoading = true
        
        do {
            let descriptor = FetchDescriptor<Emotion>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
            emotions = try modelContext.fetch(descriptor)
            isLoading = false
        } catch {
            errorMessage = "データの取得に失敗しました: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func deleteEmotion(_ emotion: Emotion) {
        guard let modelContext = modelContext else { return }
        
        modelContext.delete(emotion)
        try? modelContext.save()
        fetchEmotions()
    }
}

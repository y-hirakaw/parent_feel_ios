import SwiftUI
import SwiftData

struct MonthSection: Identifiable {
    let id: String
    let month: Date
    let emotions: [Emotion]
}

@MainActor
class HomeViewState: ObservableObject {
    @Published var path = NavigationPath()
    @Published var isEditing = false
    
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
    
    func groupEmotionsByMonth(_ emotions: [Emotion]) -> [MonthSection] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: emotions) { emotion in
            calendar.startOfMonth(for: emotion.timestamp)
        }
        
        return grouped.map { (date, emotions) in
            MonthSection(
                id: date.formatted(.dateTime.year().month()),
                month: date,
                emotions: emotions
            )
        }.sorted { $0.month > $1.month }
    }
}

private extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}

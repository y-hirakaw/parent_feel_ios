import SwiftUI
import SwiftData
import Inject

struct HomeView: View {
    @ObserveInjection var inject

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Emotion.timestamp, order: .reverse) private var emotions: [Emotion]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(emotions) { emotion in
                    NavigationLink(destination: EmotionDetailView(emotion: emotion)) {
                        HStack {
                            Text(emotion.emotionType.displayText)
                            Spacer()
                            Text(emotion.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
                    }
                }
                .onDelete(perform: deleteEmotions)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    NavigationLink(destination: EmotionInputView()) {
                        Label("感情追加", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("感情を追加するか、選択してください。")
        }
        .enableInjection()
    }

    private func deleteEmotions(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(emotions[index])
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Emotion.self, inMemory: true)
}

import SwiftUI
import SwiftData
import Inject

struct HomeView: View {
    @ObserveInjection var inject
    @State private var path = NavigationPath()

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Emotion.timestamp, order: .reverse) private var emotions: [Emotion]

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(emotions) { emotion in
                    NavigationLink(value: Screen.detail(emotion)) {
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
                    NavigationLink(value: Screen.input(nil)) {
                        Label("感情追加", systemImage: "plus")
                    }
                }
            }
            .navigationDestination(for: Screen.self) { path in
                switch path {
                case .input(let emotion):
                    EmotionInputView(emotion: emotion, path: $path)
                case .detail(let emotion):
                    EmotionDetailView(emotion: emotion, path: $path)
                case .home:
                    Text("")
                }
            }
            .navigationTitle("親の感情ノート")
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

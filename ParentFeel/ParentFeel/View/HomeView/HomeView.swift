import SwiftUI
import SwiftData
import Inject

struct HomeView: View {
    @ObserveInjection var inject
    @StateObject private var viewState: HomeViewState
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Emotion.timestamp, order: .reverse) private var emotions: [Emotion]
    
    init() {
        // SwiftUIプレビュー用に初期化
        let modelContext = try! ModelContainer(for: Emotion.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)).mainContext
        _viewState = StateObject(wrappedValue: HomeViewState(modelContext: modelContext))
    }
    
    init(modelContext: ModelContext) {
        _viewState = StateObject(wrappedValue: HomeViewState(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack(path: $viewState.path) {
            List {
                ForEach(emotions) { emotion in
                    NavigationLink(value: Screen.detail(emotion)) {
                        HStack {
                            Text(emotion.emotionType.emoji)
                            Text(emotion.emotionType.displayText)
                            Spacer()
                            Text(emotion.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
                    }
                }
                .onDelete(perform: { offsets in
                    viewState.deleteEmotions(emotions: emotions, offsets: offsets)
                })
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
                    EmotionInputView(emotion: emotion, path: $viewState.path)
                case .detail(let emotion):
                    EmotionDetailView(emotion: emotion, path: $viewState.path)
                case .home:
                    Text("")
                }
            }
            .navigationTitle("親の感情ノート")
            .onAppear {
                viewState.updateModelContext(modelContext)
            }
        }
        .enableInjection()
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Emotion.self, inMemory: true)
}

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
        TabView(selection: $viewState.selectedTab) {
            emotionListTab
                .tabItem {
                    Label("記録", systemImage: "heart.text.square")
                }
                .tag(0)
            
            EmotionTrendView()
                .tabItem {
                    Label("トレンド", systemImage: "chart.xyaxis.line")
                }
                .tag(1)
        }
        .enableInjection()
    }
    
    private var emotionListTab: some View {
        NavigationStack(path: $viewState.path) {
            Group {
                if viewState.isEditing {
                    List {
                        ForEach(emotions) { emotion in
                            EmotionCard(emotion: emotion)
                                .onTapGesture {
                                    viewState.path.append(Screen.detail(emotion))
                                }
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .listRowSeparator(.hidden)
                        }
                        .onDelete { indexSet in
                            viewState.deleteEmotions(emotions: emotions, offsets: indexSet)
                        }
                    }
                    .listStyle(.plain)
                    .environment(\.editMode, .constant(.active))
                    
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(emotions) { emotion in
                                EmotionCard(emotion: emotion)
                                    .onTapGesture {
                                        viewState.path.append(Screen.detail(emotion))
                                    }
                                    .transition(.scale.combined(with: .opacity))
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            viewState.deleteEmotion(emotion: emotion)
                                        } label: {
                                            Label("削除", systemImage: "trash")
                                        }
                                    }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("親の感情ノート")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            viewState.isEditing.toggle()
                        }
                    }) {
                        Text(viewState.isEditing ? "完了" : "編集")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
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
            .onAppear {
                viewState.updateModelContext(modelContext)
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Emotion.self, inMemory: true)
}

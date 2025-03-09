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
        .enableInjection()
    }
}

struct EmotionCard: View {
    let emotion: Emotion
    @State private var isPressed = false
    
    // 感情カテゴリに基づいて背景色を取得
    private func backgroundColor(for emotionType: EmotionType) -> Color {
        switch getCategory(for: emotionType) {
        case .positive:
            return Color.green.opacity(0.2)
        case .negative:
            return Color.red.opacity(0.2)
        case .protective:
            return Color.blue.opacity(0.2)
        case .selfReflective:
            return Color.purple.opacity(0.2)
        case .anticipatory:
            return Color.yellow.opacity(0.2)
        case .complex:
            return Color.orange.opacity(0.2)
        }
    }
    
    // 感情タイプからカテゴリを取得
    private func getCategory(for emotionType: EmotionType) -> EmotionCategory {
        for category in EmotionCategory.allCases {
            if category.emotions.contains(emotionType) {
                return category
            }
        }
        return .complex // デフォルト
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Text(emotion.emotionType.emoji)
                    .font(.system(size: 40))
                    .padding(8)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.8))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(emotion.emotionType.displayText)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(getCategory(for: emotion.emotionType).displayText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(formattedDate(emotion.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(formattedTime(emotion.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if !emotion.notes.isEmpty {
                Text(emotion.notes)
                    .font(.body)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor(for: emotion.emotionType))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3), value: isPressed)
        .onLongPressGesture(minimumDuration: 0.5, pressing: { pressing in
            isPressed = pressing
        }) {
            // 長押し完了時のアクション
        }
    }
    
    // 日付フォーマット関数
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
    // 時間フォーマット関数
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Emotion.self, inMemory: true)
}

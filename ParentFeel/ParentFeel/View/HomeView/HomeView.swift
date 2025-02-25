import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewState = HomeViewState()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if viewState.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                } else if viewState.emotions.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.text.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        Text("まだ感情の記録がありません")
                            .font(.headline)
                        Text("右上の+ボタンから感情を追加してください")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(viewState.emotions) { emotion in
                            NavigationLink(value: Screen.detail(emotion)) {
                                EmotionRowView(emotion: emotion)
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            viewState.deleteEmotion(emotion)
                                        } label: {
                                            Label("削除", systemImage: "trash")
                                        }

                                        Button {
                                            path.append(emotion)
                                        } label: {
                                            Label("編集", systemImage: "pencil")
                                        }
                                        .tint(.blue)
                                    }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        viewState.fetchEmotions()
                    }
                }
            }
            .navigationTitle("親の感情ノート")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        path.append("new_emotion")
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(for: String.self) { _ in
                EmotionInputView(path: $path)
            }
            .navigationDestination(for: Emotion.self) { emotion in
                EmotionInputView(emotion: emotion, path: $path)
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
            .alert(isPresented: Binding<Bool>(
                get: { viewState.errorMessage != nil },
                set: { if !$0 { viewState.errorMessage = nil } }
            )) {
                Alert(
                    title: Text("エラー"),
                    message: Text(viewState.errorMessage ?? "不明なエラーが発生しました"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                viewState.setModelContext(modelContext)
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Emotion.self, inMemory: true)
}

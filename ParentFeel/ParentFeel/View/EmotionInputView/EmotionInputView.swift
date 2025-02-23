import SwiftUI
import SwiftData

struct EmotionInputView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewState: EmotionInputViewState
    @Binding var path: NavigationPath

    init(emotion: Emotion? = nil, path: Binding<NavigationPath>) {
        self._viewState = StateObject(wrappedValue: EmotionInputViewState(emotion: emotion, path: path))
        self._path = path
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("起きた感情")
                        .font(.headline)
                        .padding(.horizontal)
                    ForEach(EmotionCategory.allCases) { category in
                        VStack(alignment: .leading) {
                            Text(category.displayText)
                                .font(.subheadline)
                                .padding(.horizontal)

                            LazyHGrid(rows: [GridItem(.fixed(80))], spacing: 16) {
                                ForEach(category.emotions) { emotion in
                                    Button(action: {
                                        viewState.selectedEmotion = emotion
                                    }) {
                                        VStack {
                                            Text(emotion.emoji)
                                                .font(.largeTitle)
                                                .padding(12)
                                                .background(viewState.selectedEmotion == emotion ? Color.blue.opacity(0.8) : Color.gray.opacity(0.3))
                                                .foregroundColor(.white)
                                                .clipShape(Circle())
                                                .overlay(
                                                    Circle()
                                                        .stroke(viewState.selectedEmotion == emotion ? Color.blue : Color.clear, lineWidth: 3)
                                                )
                                                .scaleEffect(viewState.selectedEmotion == emotion ? 1.1 : 1.0)
                                                .animation(.spring(), value: viewState.selectedEmotion)

                                            Text(emotion.displayText)
                                                .font(.caption)
                                                .foregroundColor(viewState.selectedEmotion == emotion ? .blue : .black)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                // 子どもの行動選択
                VStack(spacing: 8) {
                    Text("子どもの行動(任意)")
                        .font(.headline)
                    Button("選択する") {
                        viewState.isChildActionModalPresented = true
                    }
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(20)
                    .shadow(radius: 2)
                    .sheet(isPresented: $viewState.isChildActionModalPresented) {
                        ActionSelectionView(selectedActions: $viewState.selectedChildActions)
                    }
                    Text(viewState.selectedChildActions.map { $0.displayText }.joined(separator: ", "))
                        .font(.caption)
                }
                .padding(.vertical, 8)

                // 自分の行動選択
                VStack(spacing: 8) {
                    Text("自分の行動(任意)")
                        .font(.headline)
                    Button("選択する") {
                        viewState.isParentActionModalPresented = true
                    }
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(20)
                    .shadow(radius: 2)
                    .sheet(isPresented: $viewState.isParentActionModalPresented) {
                        ActionSelectionView(selectedActions: $viewState.selectedParentActions)
                    }
                    Text(viewState.selectedParentActions.map { $0.displayText }.joined(separator: ", "))
                        .font(.caption)
                }
                .padding(.vertical, 8)


                // メモ欄
                VStack(alignment: .leading) {
                    Text("メモ(任意)")
                        .font(.headline)
                        .padding(.horizontal)

                    ZStack(alignment: .topLeading) {
                        if viewState.notes.isEmpty {
                            Text("ここにメモを入力")
                                .foregroundColor(.gray)
                                .padding(10)
                        }

                        TextEditor(text: $viewState.notes)
                            .frame(height: 100)
                            .padding(10)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }

            // 保存ボタン
            Button(action: viewState.saveEmotion) {
                Text("保存")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(20)
                    .shadow(radius: 2)
            }
            .padding()
        }
        .navigationTitle("感情記録")
        .onAppear {
            viewState.setModelContext(modelContext)
        }
    }
}

#Preview {
    EmotionInputView(path: .constant(NavigationPath()))
        .modelContainer(for: Emotion.self, inMemory: true)
}

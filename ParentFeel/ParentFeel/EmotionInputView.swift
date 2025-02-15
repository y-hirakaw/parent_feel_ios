import SwiftUI
import SwiftData

struct EmotionInputView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedEmotion: EmotionType = .affection
    @State private var selectedChildActions: Set<ChildActionType> = []
    @State private var selectedParentActions: Set<ParentActionType> = []
    @State private var notes: String = ""
    @State private var isChildActionModalPresented = false
    @State private var isParentActionModalPresented = false

    let categories = EmotionCategory.allCases

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("起きた感情")
                        .font(.headline)
                        .padding(.horizontal)
                    ForEach(categories) { category in
                        VStack(alignment: .leading) {
                            Text(category.rawValue)
                                .font(.subheadline)
                                .padding(.horizontal)

                            LazyHGrid(rows: [GridItem(.fixed(80))], spacing: 16) {
                                ForEach(category.emotions) { emotion in
                                    Button(action: {
                                        selectedEmotion = emotion
                                    }) {
                                        VStack {
                                            Text(emotion.emoji)
                                                .font(.largeTitle)
                                                .padding(12)
                                                .background(selectedEmotion == emotion ? Color.blue.opacity(0.8) : Color.gray.opacity(0.3))
                                                .foregroundColor(.white)
                                                .clipShape(Circle())
                                                .overlay(
                                                    Circle()
                                                        .stroke(selectedEmotion == emotion ? Color.blue : Color.clear, lineWidth: 3)
                                                )
                                                .scaleEffect(selectedEmotion == emotion ? 1.1 : 1.0)
                                                .animation(.spring(), value: selectedEmotion)

                                            Text(emotion.displayText)
                                                .font(.caption)
                                                .foregroundColor(selectedEmotion == emotion ? .blue : .black)
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
                        isChildActionModalPresented = true
                    }
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(20)
                    .shadow(radius: 2)
                    .sheet(isPresented: $isChildActionModalPresented) {
                        ActionSelectionView(selectedActions: $selectedChildActions)
                    }
                    Text(selectedChildActions.map { $0.displayText }.joined(separator: ", "))
                        .font(.caption)
                }
                .padding(.vertical, 8)

                // 自分の行動選択
                VStack(spacing: 8) {
                    Text("自分の行動(任意)")
                        .font(.headline)
                    Button("選択する") {
                        isParentActionModalPresented = true
                    }
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(20)
                    .shadow(radius: 2)
                    .sheet(isPresented: $isParentActionModalPresented) {
                        ActionSelectionView(selectedActions: $selectedParentActions)
                    }
                    Text(selectedParentActions.map { $0.displayText }.joined(separator: ", "))
                        .font(.caption)
                }
                .padding(.vertical, 8)


                // メモ欄
                VStack(alignment: .leading) {
                    Text("メモ(任意)")
                        .font(.headline)
                        .padding(.horizontal)

                    ZStack(alignment: .topLeading) {
                        if (notes.isEmpty) {
                            Text("ここにメモを入力")
                                .foregroundColor(.gray)
                                .padding(10)
                        }

                        TextEditor(text: $notes)
                            .frame(height: 100)
                            .padding(10)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }

            // 保存ボタン
            Button(action: saveEmotion) {
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
    }

    private func saveEmotion() {
        let newEmotion = Emotion(
            emotionType: selectedEmotion,
            childActions: selectedChildActions.compactMap { ChildActionType(rawValue: $0.rawValue) },
            parentActions: selectedParentActions
                .compactMap { ParentActionType(rawValue: $0.rawValue) },
            notes: notes
        )
        modelContext.insert(newEmotion)
        print("Emotion saved: \(newEmotion.emotionType.rawValue)")
        dismiss()
    }
}

#Preview {
    EmotionInputView()
        .modelContainer(for: Emotion.self, inMemory: true)
}

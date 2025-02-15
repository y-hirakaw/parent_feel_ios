import SwiftUI
import SwiftData

struct EmotionInputView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedEmotion: String = ""
    @State private var selectedChildActions: Set<String> = []
    @State private var selectedParentActions: Set<String> = []
    @State private var notes: String = ""

    let emotions = ["Happy", "Sad", "Angry", "Surprised"]
    let childActions = ["Crying", "Laughing", "Playing"]
    let parentActions = ["Comforting", "Scolding", "Playing"]

    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    ForEach(emotions, id: \.self) { emotion in
                        Button(action: {
                            selectedEmotion = emotion
                        }) {
                            Text(emotion)
                                .padding()
                                .background(selectedEmotion == emotion ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("子どもの行動")
                    ForEach(childActions, id: \.self) { action in
                        Toggle(action, isOn: Binding(
                            get: { selectedChildActions.contains(action) },
                            set: { isSelected in
                                if isSelected {
                                    selectedChildActions.insert(action)
                                } else {
                                    selectedChildActions.remove(action)
                                }
                            }
                        ))
                    }
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("自分の行動")
                    ForEach(parentActions, id: \.self) { action in
                        Toggle(action, isOn: Binding(
                            get: { selectedParentActions.contains(action) },
                            set: { isSelected in
                                if isSelected {
                                    selectedParentActions.insert(action)
                                } else {
                                    selectedParentActions.remove(action)
                                }
                            }
                        ))
                    }
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("メモ")
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .border(Color.gray)
                }
                .padding()
            }

            Button(action: saveEmotion) {
                Text("保存")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    private func saveEmotion() {
        let newEmotion = Emotion(
            emotionType: selectedEmotion,
            childActions: Array(selectedChildActions),
            parentActions: Array(selectedParentActions),
            notes: notes
        )
        modelContext.insert(newEmotion)
        print("Emotion saved: \(newEmotion.emotionType)")
        dismiss()
    }
}

#Preview {
    EmotionInputView()
        .modelContainer(for: Emotion.self, inMemory: true)
}

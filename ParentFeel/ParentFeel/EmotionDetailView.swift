import SwiftUI

struct EmotionDetailView: View {
    let emotion: Emotion

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                detailRow(title: "起きた感情", content: "\(emotion.emotionType.emoji) \(emotion.emotionType.displayText)")
                detailRow(title: "子どもの行動", content: emotion.childActions.map { $0.displayText }.joined(separator: ", "))
                detailRow(title: "自分の行動", content: emotion.parentActions.map { $0.displayText }.joined(separator: ", "))
                detailRow(title: "メモ", content: emotion.notes, multiline: true)
                detailRow(title: "保存時間", content: emotion.timestamp.formatted(date: .numeric, time: .shortened))
            }
            .padding()
        }
        .navigationTitle("感情詳細")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EmotionInputView(emotion: emotion)) {
                    Text("編集")
                }
            }
        }
    }

    @ViewBuilder
    private func detailRow(title: String, content: String, multiline: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(content)
                .foregroundColor(.primary)
                .multilineTextAlignment(multiline ? .leading : .trailing)
        }
        .padding(.vertical, 8)
        Divider()
    }
}


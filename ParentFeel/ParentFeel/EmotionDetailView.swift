import SwiftUI

struct EmotionDetailView: View {
    let emotion: Emotion
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    HStack {
                        Text("起きた感情:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(emotion.emotionType.emoji)
                        Text(emotion.emotionType.displayText)
                            .foregroundColor(.blue)
                    }
                    Divider()
                    
                    HStack {
                        Text("子どもの行動:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(emotion.childActions.map { $0.displayText }.joined(separator: ", "))
                            .foregroundColor(.blue)
                    }
                    Divider()
                    
                    HStack {
                        Text("自分の行動:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(emotion.parentActions.map { $0.displayText }.joined(separator: ", "))
                            .foregroundColor(.blue)
                    }
                    Divider()
                    
                    HStack {
                        Text("メモ:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(emotion.notes)
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.trailing)
                    }
                    Divider()
                    
                    HStack {
                        Text("保存時間:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(emotion.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 8)
            }
            .padding()
        }
        .navigationTitle("感情詳細")
    }
}

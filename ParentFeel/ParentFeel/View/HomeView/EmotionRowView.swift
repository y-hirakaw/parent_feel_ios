import SwiftUI

struct EmotionRowView: View {
    let emotion: Emotion
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // 感情の絵文字を表示
            Text(emotion.emotionType.emoji)
                .font(.system(size: 40))
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                // 感情タイプ
                Text(emotion.emotionType.displayText)
                    .font(.headline)
                    .foregroundColor(.black)
                
                // タイムスタンプ
                Text(formattedDate(emotion.timestamp))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // 子どもの行動
                if !emotion.childActions.isEmpty {
                    Text("子どもの行動: \(emotion.childActions.map { $0.displayText }.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                // 親の行動
                if !emotion.parentActions.isEmpty {
                    Text("自分の行動: \(emotion.parentActions.map { $0.displayText }.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}

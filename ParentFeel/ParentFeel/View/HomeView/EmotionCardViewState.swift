import SwiftUI
import SwiftData

class EmotionCardViewState: ObservableObject {
    let emotion: Emotion
    @Published var isPressed = false
    
    init(emotion: Emotion) {
        self.emotion = emotion
    }
    
    // 感情タイプからカテゴリを取得
    func getCategory(for emotionType: EmotionType) -> EmotionCategory {
        for category in EmotionCategory.allCases {
            if category.emotions.contains(emotionType) {
                return category
            }
        }
        return .complex // デフォルト
    }
    
    // 感情カテゴリに基づいて背景色を取得
    func backgroundColor(for emotionType: EmotionType) -> Color {
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
    
    // 日付フォーマット関数
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
    // 時間フォーマット関数
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
    // 長押し状態を更新
    func updatePressState(_ isPressed: Bool) {
        withAnimation(.spring(response: 0.3)) {
            self.isPressed = isPressed
        }
    }
}
import SwiftUI
import SwiftData

class EmotionTrendViewState: ObservableObject {
    // 日付範囲内のカテゴリ別感情数を集計するメソッド
    func emotionCountsByCategory(emotions: [Emotion]) -> [EmotionCategory: Int] {
        var counts: [EmotionCategory: Int] = [:]
        
        for category in EmotionCategory.allCases {
            counts[category] = 0
        }
        
        for emotion in emotions {
            for category in EmotionCategory.allCases {
                if category.emotions.contains(emotion.emotionType) {
                    counts[category] = (counts[category] ?? 0) + 1
                    break
                }
            }
        }
        
        return counts
    }
    
    // 日付範囲内の感情タイプ別の数を集計するメソッド
    func emotionCountsByType(emotions: [Emotion]) -> [EmotionType: Int] {
        var counts: [EmotionType: Int] = [:]
        
        for type in EmotionType.allCases {
            counts[type] = 0
        }
        
        for emotion in emotions {
            counts[emotion.emotionType] = (counts[emotion.emotionType] ?? 0) + 1
        }
        
        return counts
    }
}
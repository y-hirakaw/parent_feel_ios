import XCTest
import Testing
import SwiftData
@testable import ParentFeel

@Suite("EmotionTrendViewState Tests")
struct EmotionTrendViewStateTests {
    
    // テスト用のデータ作成ヘルパー
    func createTestEmotions() -> [Emotion] {
        let emotion1 = Emotion(
            emotionType: .joy, // 肯定的感情
            childActions: [],
            parentActions: [],
            notes: "Test joy"
        )
        
        let emotion2 = Emotion(
            emotionType: .anger, // 否定的感情
            childActions: [],
            parentActions: [],
            notes: "Test anger"
        )
        
        let emotion3 = Emotion(
            emotionType: .fear, // 保護的感情
            childActions: [],
            parentActions: [],
            notes: "Test fear"
        )
        
        let emotion4 = Emotion(
            emotionType: .joy, // 肯定的感情 (重複)
            childActions: [],
            parentActions: [],
            notes: "Test joy again"
        )
        
        return [emotion1, emotion2, emotion3, emotion4]
    }
    
    @Test("emotionCountsByCategory - カテゴリー別に感情数を正しく集計する")
    func testEmotionCountsByCategory() {
        // 準備
        let viewState = EmotionTrendViewState()
        let emotions = createTestEmotions()
        
        // 実行
        let counts = viewState.emotionCountsByCategory(emotions: emotions)
        
        // 検証
        #expect(counts[.positive] == 2) // joyが2回
        #expect(counts[.negative] == 1) // angerが1回
        #expect(counts[.protective] == 1) // fearが1回
        #expect(counts[.selfReflective] == 0) // 該当なし
        #expect(counts[.anticipatory] == 0) // 該当なし
        #expect(counts[.complex] == 0) // 該当なし
    }
    
    @Test("emotionCountsByCategory - 空の配列の場合は全てのカテゴリが0")
    func testEmotionCountsByCategoryWithEmptyArray() {
        // 準備
        let viewState = EmotionTrendViewState()
        
        // 実行
        let counts = viewState.emotionCountsByCategory(emotions: [])
        
        // 検証
        for category in EmotionCategory.allCases {
            #expect(counts[category] == 0)
        }
    }
    
    @Test("emotionCountsByType - タイプ別に感情数を正しく集計する")
    func testEmotionCountsByType() {
        // 準備
        let viewState = EmotionTrendViewState()
        let emotions = createTestEmotions()
        
        // 実行
        let counts = viewState.emotionCountsByType(emotions: emotions)
        
        // 検証
        #expect(counts[.joy] == 2)
        #expect(counts[.anger] == 1)
        #expect(counts[.fear] == 1)
        
        // 存在しないタイプは0になっていること
        #expect(counts[.guilt] == 0)
        #expect(counts[.hope] == 0)
    }
    
    @Test("emotionCountsByType - 空の配列の場合は全てのタイプが0")
    func testEmotionCountsByTypeWithEmptyArray() {
        // 準備
        let viewState = EmotionTrendViewState()
        
        // 実行
        let counts = viewState.emotionCountsByType(emotions: [])
        
        // 検証
        for type in EmotionType.allCases {
            #expect(counts[type] == 0)
        }
    }
}
import XCTest
import Testing
import SwiftUI
@testable import ParentFeel

@Suite("EmotionCardViewState Tests")
struct EmotionCardViewStateTests {
    
    let testEmotion = Emotion(
        emotionType: .joy,
        childActions: [.crying, .laughing],
        parentActions: [.hugging, .listening],
        notes: "テストメモ"
    )
    
    @Test("getCategory - returns correct category for emotion type")
    func testGetCategory() throws {
        // 準備
        let viewState = EmotionCardViewState(emotion: testEmotion)
        
        // 検証
        #expect(viewState.getCategory(for: .joy) == .positive)
        #expect(viewState.getCategory(for: .anger) == .negative)
        #expect(viewState.getCategory(for: .anxiety) == .protective)
        #expect(viewState.getCategory(for: .guilt) == .selfReflective)
        #expect(viewState.getCategory(for: .hope) == .anticipatory)
        #expect(viewState.getCategory(for: .jealousy) == .complex)
    }
    
    @Test("backgroundColor - returns correct color for emotion type")
    func testBackgroundColor() throws {
        // 準備
        let viewState = EmotionCardViewState(emotion: testEmotion)
        
        // 検証
        #expect(viewState.backgroundColor(for: .joy) == Color.green.opacity(0.2))
        #expect(viewState.backgroundColor(for: .anger) == Color.red.opacity(0.2))
        #expect(viewState.backgroundColor(for: .anxiety) == Color.blue.opacity(0.2))
        #expect(viewState.backgroundColor(for: .guilt) == Color.purple.opacity(0.2))
        #expect(viewState.backgroundColor(for: .hope) == Color.yellow.opacity(0.2))
        #expect(viewState.backgroundColor(for: .jealousy) == Color.orange.opacity(0.2))
    }
    
    @Test("formattedDate - returns date in correct format")
    func testFormattedDate() throws {
        // 準備
        let viewState = EmotionCardViewState(emotion: testEmotion)
        let testDate = Calendar.current.date(from: DateComponents(year: 2023, month: 5, day: 15))!
        
        // 実行
        let result = viewState.formattedDate(testDate)
        
        // 検証
        // 日本語ロケールで "2023年5月15日" のような形式になることを期待
        #expect(result.contains("2023"))
        #expect(result.contains("5"))
        #expect(result.contains("15"))
    }
    
    @Test("formattedTime - returns time in correct format")
    func testFormattedTime() throws {
        // 準備
        let viewState = EmotionCardViewState(emotion: testEmotion)
        let testTime = Calendar.current.date(from: DateComponents(hour: 14, minute: 30))!
        
        // 実行
        let result = viewState.formattedTime(testTime)
        
        // 検証
        // 日本語ロケールで "14:30" のような形式になることを期待
        #expect(result.contains("14:30") || result.contains("2:30"))
    }
    
    @Test("updatePressState - updates isPressed property")
    func testUpdatePressState() throws {
        // 準備
        let viewState = EmotionCardViewState(emotion: testEmotion)
        #expect(viewState.isPressed == false)
        
        // 実行
        viewState.updatePressState(true)
        
        // 検証
        #expect(viewState.isPressed == true)
        
        // 実行
        viewState.updatePressState(false)
        
        // 検証
        #expect(viewState.isPressed == false)
    }
}
import XCTest
import Testing
import SwiftUI
@testable import ParentFeel

@MainActor
@Suite("EmotionDetailViewState Tests")
struct EmotionDetailViewStateTests {
    
    // テスト用のEmotionオブジェクト
    let testEmotion = Emotion(
        emotionType: .joy,
        childActions: [.crying, .laughing],
        parentActions: [.hugging, .listening],
        notes: "テストメモ",
        pastExperience: "子どもの頃の体験",
        pastExperienceFeeling: "楽しかった",
        pastExperienceSentiment: "positive",
        desiredResponse: "優しく対応したい"
    )
    
    let emptyEmotion = Emotion(
        emotionType: .fear,
        childActions: [],
        parentActions: [],
        notes: "",
        pastExperience: "",
        pastExperienceFeeling: "",
        pastExperienceSentiment: "",
        desiredResponse: ""
    )
    
    @Test("EmotionDetailViewState - 自己振り返り関連のプロパティが正しく取得される")
    func testSelfReflectionProperties() throws {
        // 準備
        let viewState = EmotionDetailViewState(emotion: testEmotion)
        
        // 検証 - 各プロパティが正しい値を返すことを確認
        #expect(viewState.pastExperienceText == "子どもの頃の体験")
        #expect(viewState.pastExperienceFeelingText == "楽しかった")
        #expect(viewState.pastExperienceSentimentText == "ポジティブ")
        #expect(viewState.desiredResponseText == "優しく対応したい")
    }
    
    @Test("EmotionDetailViewState - pastExperienceSentimentText が正しい文字列を返す")
    func testPastExperienceSentimentText() throws {
        // 準備 - 異なるsentiment値でテスト
        let positiveEmotion = createEmotionWithSentiment("positive")
        let negativeEmotion = createEmotionWithSentiment("negative")
        let emptyEmotion = createEmotionWithSentiment("")
        
        let positiveState = EmotionDetailViewState(emotion: positiveEmotion)
        let negativeState = EmotionDetailViewState(emotion: negativeEmotion)
        let emptyState = EmotionDetailViewState(emotion: emptyEmotion)
        
        // 検証
        #expect(positiveState.pastExperienceSentimentText == "ポジティブ")
        #expect(negativeState.pastExperienceSentimentText == "ネガティブ")
        #expect(emptyState.pastExperienceSentimentText == "")
    }
    
    @Test("EmotionDetailViewState - 既存フィールド（emotionTypeText, notesText など）も正しく取得される")
    func testExistingProperties() throws {
        // 準備
        let viewState = EmotionDetailViewState(emotion: testEmotion)
        
        // 検証 - 既存のプロパティも正しい値を返すことを確認
        // EmotionTypeのdisplayTextを直接使用
        #expect(viewState.emotionTypeText.contains(testEmotion.emotionType.emoji))
        #expect(viewState.emotionTypeText.contains(testEmotion.emotionType.displayText))
        #expect(viewState.childActionsText.contains(testEmotion.childActions[0].displayText))
        #expect(viewState.childActionsText.contains(testEmotion.childActions[1].displayText))
        #expect(viewState.parentActionsText.contains(testEmotion.parentActions[0].displayText))
        #expect(viewState.parentActionsText.contains(testEmotion.parentActions[1].displayText))
        #expect(viewState.notesText == "テストメモ")
    }
    
    @Test("EmotionDetailViewState - 空の値が正しく処理される")
    func testEmptyValues() throws {
        // 準備
        let viewState = EmotionDetailViewState(emotion: emptyEmotion)
        
        // 検証 - 空の値が正しく処理されることを確認
        #expect(viewState.pastExperienceText.isEmpty)
        #expect(viewState.pastExperienceFeelingText.isEmpty)
        #expect(viewState.pastExperienceSentimentText.isEmpty)
        #expect(viewState.desiredResponseText.isEmpty)
        #expect(viewState.notesText.isEmpty)
    }
    
    // テスト用のヘルパーメソッド
    func createEmotionWithSentiment(_ sentiment: String) -> Emotion {
        return Emotion(
            emotionType: .joy,
            childActions: [],
            parentActions: [],
            notes: "",
            pastExperience: "",
            pastExperienceFeeling: "",
            pastExperienceSentiment: sentiment,
            desiredResponse: ""
        )
    }
}

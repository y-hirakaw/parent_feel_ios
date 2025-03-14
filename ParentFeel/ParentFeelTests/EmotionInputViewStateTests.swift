import XCTest
import Testing
import SwiftUI
import SwiftData
@testable import ParentFeel

@MainActor
@Suite("EmotionInputViewState Tests")
struct EmotionInputViewStateTests {
    
    // シンプルなテスト用のEmotionオブジェクト
    func createTestEmotion() -> Emotion {
        return Emotion(
            emotionType: .joy,
            childActions: [.crying, .laughing],
            parentActions: [.hugging, .listening],
            notes: "テストメモ",
            pastExperience: "子どもの頃の体験",
            pastExperienceFeeling: "楽しかった",
            pastExperienceSentiment: "positive",
            desiredResponse: "優しく対応したい"
        )
    }
    
    @Test("初期化時に正しい値がセットされる - 新規作成の場合")
    func testInitDefaultValues() throws {
        // 実行
        let path = Binding.constant(NavigationPath())
        let viewState = EmotionInputViewState(emotion: nil, path: path)
        
        // 検証 - デフォルト値が正しくセットされていることを確認
        #expect(viewState.selectedEmotion == .affection)
        #expect(viewState.selectedChildActions.isEmpty)
        #expect(viewState.selectedParentActions.isEmpty)
        #expect(viewState.notes == "")
        #expect(viewState.pastExperience == "")
        #expect(viewState.pastExperienceFeeling == "")
        #expect(viewState.pastExperienceSentiment == "")
        #expect(viewState.desiredResponse == "")
    }
    
    @Test("初期化時に正しい値がセットされる - 既存の感情を編集する場合")
    func testInitWithExistingEmotion() throws {
        // 準備
        let testEmotion = createTestEmotion()
        let path = Binding.constant(NavigationPath())
        
        // 実行
        let viewState = EmotionInputViewState(emotion: testEmotion, path: path)
        
        // 検証 - 既存の感情の値が正しくセットされていることを確認
        #expect(viewState.selectedEmotion == .joy)
        #expect(viewState.selectedChildActions.contains(.crying))
        #expect(viewState.selectedChildActions.contains(.laughing))
        #expect(viewState.selectedParentActions.contains(.hugging))
        #expect(viewState.selectedParentActions.contains(.listening))
        #expect(viewState.notes == "テストメモ")
        #expect(viewState.pastExperience == "子どもの頃の体験")
        #expect(viewState.pastExperienceFeeling == "楽しかった")
        #expect(viewState.pastExperienceSentiment == "positive")
        #expect(viewState.desiredResponse == "優しく対応したい")
    }
    
    @Test("自己振り返りフィールドが正しく処理される")
    func testSelfReflectionFields() throws {
        // 準備
        let path = Binding.constant(NavigationPath())
        let viewState = EmotionInputViewState(path: path)
        
        // 値を設定
        viewState.pastExperience = "新しい過去の経験"
        viewState.pastExperienceFeeling = "新しい感じ方"
        viewState.pastExperienceSentiment = "negative"
        viewState.desiredResponse = "新しい対応方法"
        
        // 検証
        #expect(viewState.pastExperience == "新しい過去の経験")
        #expect(viewState.pastExperienceFeeling == "新しい感じ方")
        #expect(viewState.pastExperienceSentiment == "negative")
        #expect(viewState.desiredResponse == "新しい対応方法")
    }
}

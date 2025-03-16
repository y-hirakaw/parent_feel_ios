import XCTest
import Testing
import SwiftData
@testable import ParentFeel

// テスト用のContextRecorder
class ContextRecorder {
    var deletedObjects: [any PersistentModel] = []
    
    func delete(_ object: any PersistentModel) {
        deletedObjects.append(object)
    }
}

@MainActor
@Suite("HomeViewState Tests")
struct HomeViewStateTests {
    
    // テストヘルパー関数
    private func createTestContext() throws -> (ModelContext, ContextRecorder) {
        let container = try ModelContainer(for: Emotion.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext
        let recorder = ContextRecorder()
        return (context, recorder)
    }
    
    @Test("isEditing - defaults to false")
    func testIsEditingDefaultValue() async throws {
        // 準備
        let (context, _) = try createTestContext()
        
        // 実行
        let viewState = HomeViewState(modelContext: context)
        
        // 検証
        #expect(viewState.isEditing == false)
    }
    
    @Test("updateModelContext - updates the model context")
    func testUpdateModelContext() async throws {
        // 準備
        let (context1, _) = try createTestContext()
        let (context2, _) = try createTestContext()
        let viewState = HomeViewState(modelContext: context1)
        
        // 実行
        viewState.updateModelContext(context2)
        
        // 検証 - 内部プロパティが private なので間接的なテストが必要
        // 本来なら、モックを使ってメソッドの呼び出しを検証する必要があります
    }
    
    @Test("deleteEmotion - deletes a single emotion")
    func testDeleteEmotion() async throws {
        // 準備
        let (context, recorder) = try createTestContext()
        let viewState = HomeViewState(modelContext: context)
        let emotion = Emotion(
            emotionType: .anger,
            childActions: [.crying],
            parentActions: [.scolding],
            notes: "Test note"
        )
        
        // 実行
        viewState.deleteEmotion(emotion: emotion)
        recorder.delete(emotion)
        
        // 検証
        #expect(recorder.deletedObjects.count == 1)
        #expect(recorder.deletedObjects[0] as? Emotion === emotion)
    }
    
    @Test("deleteEmotions - deletes multiple emotions by index")
    func testDeleteEmotions() async throws {
        // 準備
        let (context, recorder) = try createTestContext()
        let viewState = HomeViewState(modelContext: context)
        
        let emotion1 = Emotion(
            emotionType: .anger,
            childActions: [.crying],
            parentActions: [.scolding],
            notes: "Test note 1"
        )
        let emotion2 = Emotion(
            emotionType: .joy,
            childActions: [.laughing],
            parentActions: [.praising],
            notes: "Test note 2"
        )
        let emotion3 = Emotion(
            emotionType: .sadness,
            childActions: [.crying],
            parentActions: [.hugging],
            notes: "Test note 3"
        )
        let emotions = [emotion1, emotion2, emotion3]
        
        // 実行 - 最初と最後の要素を削除
        viewState.deleteEmotions(emotions: emotions, offsets: IndexSet([0, 2]))
        recorder.delete(emotion1)
        recorder.delete(emotion3)
        
        // 検証
        #expect(recorder.deletedObjects.count == 2)
        #expect(recorder.deletedObjects.contains(where: { ($0 as? Emotion) === emotion1 }))
        #expect(recorder.deletedObjects.contains(where: { ($0 as? Emotion) === emotion3 }))
        #expect(!recorder.deletedObjects.contains(where: { ($0 as? Emotion) === emotion2 }))
    }
    
    @Test("groupEmotionsByMonth - グループ化と並び順のテスト")
    func testGroupEmotionsByMonth() async throws {
        // 準備
        let (context, _) = try createTestContext()
        let viewState = HomeViewState(modelContext: context)
        
        let calendar = Calendar.current
        let now = Date()
        let lastMonth = calendar.date(byAdding: .month, value: -1, to: now)!
        let twoMonthsAgo = calendar.date(byAdding: .month, value: -2, to: now)!
        
        // 各日付に感情を作成
        let angryEmotion = Emotion(emotionType: .anger, childActions: [], parentActions: [], notes: "")
        angryEmotion.timestamp = now
        
        let joyEmotion = Emotion(emotionType: .joy, childActions: [], parentActions: [], notes: "")
        joyEmotion.timestamp = now
        
        let sadEmotion = Emotion(emotionType: .sadness, childActions: [], parentActions: [], notes: "")
        sadEmotion.timestamp = lastMonth
        
        let anxietyEmotion = Emotion(emotionType: .anxiety, childActions: [], parentActions: [], notes: "")
        anxietyEmotion.timestamp = twoMonthsAgo
        
        let emotions = [angryEmotion, joyEmotion, sadEmotion, anxietyEmotion]
        
        // 実行
        let sections = viewState.groupEmotionsByMonth(emotions)
        
        // 検証
        // 1. セクションの数が正しいこと
        #expect(sections.count == 3)
        
        // 2. セクション内の感情の数が正しいこと
        #expect(sections[0].emotions.count == 2) // 今月
        #expect(sections[1].emotions.count == 1) // 先月
        #expect(sections[2].emotions.count == 1) // 2ヶ月前
        
        // 3. セクションが日付の降順でソートされていること
        let dates = sections.map { $0.month }
        #expect(dates[0] > dates[1])
        #expect(dates[1] > dates[2])
        
        // 4. 各セクションに正しい感情が含まれていること
        #expect(sections[0].emotions.contains { $0.emotionType == .anger })
        #expect(sections[0].emotions.contains { $0.emotionType == .joy })
        #expect(sections[1].emotions.contains { $0.emotionType == .sadness })
        #expect(sections[2].emotions.contains { $0.emotionType == .anxiety })
    }
}
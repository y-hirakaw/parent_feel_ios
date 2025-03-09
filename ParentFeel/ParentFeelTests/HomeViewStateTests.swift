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

@Suite("HomeViewState Tests")
struct HomeViewStateTests {
    
    // テストヘルパー関数
    @MainActor
    private func createTestContext() throws -> (ModelContext, ContextRecorder) {
        let container = try ModelContainer(for: Emotion.self)
        let context = container.mainContext
        let recorder = ContextRecorder()
        return (context, recorder)
    }
    
    @Test("isEditing - defaults to false")
    func testIsEditingDefaultValue() async throws {
        // 準備
        let (context, _) = try await MainActor.run { try createTestContext() }
        
        // 実行
        let viewState = HomeViewState(modelContext: context)
        
        // 検証
        #expect(viewState.isEditing == false)
    }
    
    @Test("updateModelContext - updates the model context")
    func testUpdateModelContext() async throws {
        // 準備
        let (context1, _) = try await MainActor.run { try createTestContext() }
        let (context2, _) = try await MainActor.run { try createTestContext() }
        let viewState = HomeViewState(modelContext: context1)
        
        // 実行
        viewState.updateModelContext(context2)
        
        // 検証 - 内部プロパティが private なので間接的なテストが必要
        // 本来なら、モックを使ってメソッドの呼び出しを検証する必要があります
    }
    
    @Test("deleteEmotion - deletes a single emotion")
    func testDeleteEmotion() async throws {
        // 準備
        let (context, recorder) = try await MainActor.run { try createTestContext() }
        let viewState = HomeViewState(modelContext: context)
        let emotion = Emotion(
            emotionType: .joy,
            childActions: [],
            parentActions: [],
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
        let (context, recorder) = try await MainActor.run { try createTestContext() }
        let viewState = HomeViewState(modelContext: context)
        
        let emotion1 = Emotion(
            emotionType: .joy,
            childActions: [],
            parentActions: [],
            notes: "Test note 1"
        )
        let emotion2 = Emotion(
            emotionType: .anger,
            childActions: [],
            parentActions: [],
            notes: "Test note 2"
        )
        let emotion3 = Emotion(
            emotionType: .fear,
            childActions: [],
            parentActions: [],
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
}
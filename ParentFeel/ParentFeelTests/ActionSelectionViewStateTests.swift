import Testing
import SwiftUI
@testable import ParentFeel

@Suite("ActionSelectionViewState Tests")
struct ActionSelectionViewStateTests {
    // テスト用のUserDefaultsキーを作成（本番のデータを汚さないため）
    private static let testUserDefaultsSuite = "test_action_selection_view_state"
    
    @Test("カテゴリAllですべてのアクションを取得できる")
    func testFilteredActionsAll() throws {
        // テスト用のUserDefaultsを準備
        let userDefaults = UserDefaults(suiteName: Self.testUserDefaultsSuite)!
        userDefaults.removePersistentDomain(forName: Self.testUserDefaultsSuite)
        
        // UserDefaultsをモック化するテスト用のViewState
        let viewState = TestableActionSelectionViewState<ChildActionType>(userDefaults: userDefaults)
        
        // すべてのカテゴリが選択された場合
        viewState.selectedCategory = .all
        
        // 全てのアクションが含まれているはず
        #expect(viewState.filteredActions().count == ChildActionType.allCases.count)
    }
    
    @Test("ポジティブカテゴリでポジティブなアクションのみが取得できる")
    func testFilteredActionsPositive() throws {
        // テスト用のUserDefaultsを準備
        let userDefaults = UserDefaults(suiteName: Self.testUserDefaultsSuite)!
        userDefaults.removePersistentDomain(forName: Self.testUserDefaultsSuite)
        
        // UserDefaultsをモック化するテスト用のViewState
        let viewState = TestableActionSelectionViewState<ChildActionType>(userDefaults: userDefaults)
        
        // ポジティブカテゴリが選択された場合
        viewState.selectedCategory = .positive
        
        // ポジティブなアクションのみが含まれているはず
        let filteredActions = viewState.filteredActions()
        #expect(filteredActions.contains(ChildActionType.laughing))
        #expect(filteredActions.contains(ChildActionType.helping))
        #expect(filteredActions.contains(ChildActionType.sharing))
        
        // ネガティブなアクションは含まれていないはず
        #expect(!filteredActions.contains(ChildActionType.crying))
        #expect(!filteredActions.contains(ChildActionType.screaming))
    }
    
    @Test("ネガティブカテゴリでネガティブなアクションのみが取得できる")
    func testFilteredActionsNegative() throws {
        // テスト用のUserDefaultsを準備
        let userDefaults = UserDefaults(suiteName: Self.testUserDefaultsSuite)!
        userDefaults.removePersistentDomain(forName: Self.testUserDefaultsSuite)
        
        // UserDefaultsをモック化するテスト用のViewState
        let viewState = TestableActionSelectionViewState<ChildActionType>(userDefaults: userDefaults)
        
        // ネガティブカテゴリが選択された場合
        viewState.selectedCategory = .negative
        
        // ネガティブなアクションのみが含まれているはず
        let filteredActions = viewState.filteredActions()
        #expect(filteredActions.contains(ChildActionType.crying))
        #expect(filteredActions.contains(ChildActionType.screaming))
        #expect(filteredActions.contains(ChildActionType.throwingThings))
        
        // ポジティブなアクションは含まれていないはず
        #expect(!filteredActions.contains(ChildActionType.laughing))
        #expect(!filteredActions.contains(ChildActionType.helping))
    }
    
    @Test("検索機能で特定のアクションがフィルタリングできる")
    func testSearchFunctionality() throws {
        // テスト用のUserDefaultsを準備
        let userDefaults = UserDefaults(suiteName: Self.testUserDefaultsSuite)!
        userDefaults.removePersistentDomain(forName: Self.testUserDefaultsSuite)
        
        // UserDefaultsをモック化するテスト用のViewState
        let viewState = TestableActionSelectionViewState<ChildActionType>(userDefaults: userDefaults)
        
        // すべてのカテゴリで「泣く」を検索
        viewState.selectedCategory = .all
        viewState.searchText = "泣く"
        
        // 泣くのみが含まれているはず
        let filteredActions = viewState.filteredActions()
        #expect(filteredActions.count == 1)
        #expect(filteredActions.contains(ChildActionType.crying))
    }
    
    @Test("存在しない検索文字列で結果が空になる")
    func testSearchWithNoResults() throws {
        // テスト用のUserDefaultsを準備
        let userDefaults = UserDefaults(suiteName: Self.testUserDefaultsSuite)!
        userDefaults.removePersistentDomain(forName: Self.testUserDefaultsSuite)
        
        // UserDefaultsをモック化するテスト用のViewState
        let viewState = TestableActionSelectionViewState<ChildActionType>(userDefaults: userDefaults)
        
        // 存在しない文字列で検索
        viewState.selectedCategory = .all
        viewState.searchText = "存在しない行動"
        
        // 結果は空のはず
        #expect(viewState.filteredActions().isEmpty)
    }
    
    @Test("特定のカテゴリ内で検索ができる")
    func testSearchInSpecificCategory() throws {
        // テスト用のUserDefaultsを準備
        let userDefaults = UserDefaults(suiteName: Self.testUserDefaultsSuite)!
        userDefaults.removePersistentDomain(forName: Self.testUserDefaultsSuite)
        
        // UserDefaultsをモック化するテスト用のViewState
        let viewState = TestableActionSelectionViewState<ChildActionType>(userDefaults: userDefaults)
        
        // ポジティブカテゴリで「笑」を検索
        viewState.selectedCategory = .positive
        viewState.searchText = "笑"
        
        // 笑うのみが含まれているはず
        let filteredActions = viewState.filteredActions()
        #expect(filteredActions.count == 1)
        #expect(filteredActions.contains(ChildActionType.laughing))
    }
    
    @Test("アクション選択の切り替えができる")
    func testToggleAction() throws {
        // テスト用のUserDefaultsを準備
        let userDefaults = UserDefaults(suiteName: Self.testUserDefaultsSuite)!
        userDefaults.removePersistentDomain(forName: Self.testUserDefaultsSuite)
        
        // UserDefaultsをモック化するテスト用のViewState
        let viewState = TestableActionSelectionViewState<ChildActionType>(userDefaults: userDefaults)
        
        // 初期状態では選択されていない
        #expect(!viewState.contains(ChildActionType.crying))
        
        // 選択する
        viewState.toggle(ChildActionType.crying)
        #expect(viewState.contains(ChildActionType.crying))
        
        // もう一度トグルすると選択解除される
        viewState.toggle(ChildActionType.crying)
        #expect(!viewState.contains(ChildActionType.crying))
    }
    
    @Test("アクションの追加と削除ができる")
    func testInsertAndRemoveAction() throws {
        // テスト用のUserDefaultsを準備
        let userDefaults = UserDefaults(suiteName: Self.testUserDefaultsSuite)!
        userDefaults.removePersistentDomain(forName: Self.testUserDefaultsSuite)
        
        // UserDefaultsをモック化するテスト用のViewState
        let viewState = TestableActionSelectionViewState<ChildActionType>(userDefaults: userDefaults)
        
        // 追加
        viewState.insert(ChildActionType.crying)
        #expect(viewState.contains(ChildActionType.crying))
        
        // 削除
        viewState.remove(ChildActionType.crying)
        #expect(!viewState.contains(ChildActionType.crying))
    }
    
    @Test("最近使用したアクションが正しい順序で取得できる")
    func testRecentActions() throws {
        // テスト用のUserDefaultsを準備
        let userDefaults = UserDefaults(suiteName: Self.testUserDefaultsSuite)!
        userDefaults.removePersistentDomain(forName: Self.testUserDefaultsSuite)
        
        // UserDefaultsをモック化するテスト用のViewState
        let viewState = TestableActionSelectionViewState<ChildActionType>(userDefaults: userDefaults)
        
        // いくつかのアクションを選択
        viewState.insert(ChildActionType.crying)
        viewState.insert(ChildActionType.laughing)
        viewState.insert(ChildActionType.helping)
        
        // 最近使用したカテゴリを選択
        viewState.selectedCategory = .recent
        
        // 選択した3つのアクションが含まれているはず（最新順）
        let recentActions = viewState.filteredActions()
        #expect(recentActions.count == 3)
        
        // 最新のものが先頭になるので、逆順でチェック
        #expect(recentActions[0] == ChildActionType.helping)
        #expect(recentActions[1] == ChildActionType.laughing)
        #expect(recentActions[2] == ChildActionType.crying)
    }
    
    @Test("最近使用したアクションは上限数を超えない")
    func testRecentActionsLimit() throws {
        // テスト用のUserDefaultsを準備
        let userDefaults = UserDefaults(suiteName: Self.testUserDefaultsSuite)!
        userDefaults.removePersistentDomain(forName: Self.testUserDefaultsSuite)
        
        // UserDefaultsをモック化するテスト用のViewState
        let viewState = TestableActionSelectionViewState<ChildActionType>(userDefaults: userDefaults)
        
        // 最大表示数以上のアクションを選択（デフォルトは5）
        viewState.insert(ChildActionType.crying)
        viewState.insert(ChildActionType.laughing)
        viewState.insert(ChildActionType.helping)
        viewState.insert(ChildActionType.sharing)
        viewState.insert(ChildActionType.concentrating)
        viewState.insert(ChildActionType.beingKind) // 6つ目
        
        // 最近使用したカテゴリを選択
        viewState.selectedCategory = .recent
        
        // 最大5つまでしか保持されないはず
        #expect(viewState.filteredActions().count == 5)
        
        // 古いものが消えて新しいものが残っているはず
        #expect(viewState.filteredActions().contains(ChildActionType.beingKind))
        #expect(!viewState.filteredActions().contains(ChildActionType.crying))
    }
    
    @Test("最近使用したアクションがUserDefaultsに保存・復元される")
    func testRecentActionsPersistence() throws {
        // テスト用のUserDefaultsを準備
        let userDefaults = UserDefaults(suiteName: Self.testUserDefaultsSuite)!
        userDefaults.removePersistentDomain(forName: Self.testUserDefaultsSuite)
        
        // UserDefaultsをモック化するテスト用のViewState
        let viewState = TestableActionSelectionViewState<ChildActionType>(userDefaults: userDefaults)
        
        // アクションを選択してUserDefaultsに保存
        viewState.insert(ChildActionType.crying)
        viewState.insert(ChildActionType.laughing)
        
        // 新しいインスタンスを作成（UserDefaultsから読み込む）
        let newViewState = TestableActionSelectionViewState<ChildActionType>(userDefaults: userDefaults)
        
        // 最近使用したカテゴリを選択
        newViewState.selectedCategory = .recent
        
        // 前回選択したアクションが保持されているはず
        let recentActions = newViewState.filteredActions()
        #expect(recentActions.count == 2)
        #expect(recentActions.contains(ChildActionType.crying))
        #expect(recentActions.contains(ChildActionType.laughing))
    }
    
    @Test("ActionCategoryの表示テキストが正しい")
    func testActionCategoryDisplayText() throws {
        // 各カテゴリの表示テキストが期待通りか
        #expect(ActionCategory.all.displayText == "すべて")
        #expect(ActionCategory.positive.displayText == "ポジティブ")
        #expect(ActionCategory.negative.displayText == "ネガティブ")
        #expect(ActionCategory.neutral.displayText == "ニュートラル")
        #expect(ActionCategory.recent.displayText == "最近使用")
    }
}

// テスト用のActionSelectionViewStateサブクラス（UserDefaultsをモック化）
class TestableActionSelectionViewState<T: ActionType>: ActionSelectionViewState<T> {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        super.init()
    }
    
    // UserDefaultsをオーバーライド
    override func getUserDefaults() -> UserDefaults {
        return userDefaults
    }
}
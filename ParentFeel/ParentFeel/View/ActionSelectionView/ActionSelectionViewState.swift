import SwiftUI

/// アクション選択ビューの状態を管理するクラス
class ActionSelectionViewState<T: ActionType>: ObservableObject {
    /// 選択されたアクションのセット
    @Published var selectedActions: Set<T> = []
    /// 検索テキスト
    @Published var searchText: String = ""
    /// 現在選択されているカテゴリ
    @Published var selectedCategory: ActionCategory = .all
    /// 最近使用したアクション
    @Published var recentActions: [T] = []
    
    /// 最大表示する最近使用した項目の数
    private let maxRecentActions = 5
    
    /// 各カテゴリに分類された行動
    private var categorizedActions: [ActionCategory: [T]] = [:]
    
    /// 初期化
    init() {
        setupCategories()
        loadRecentActions()
    }
    
    /// テスト可能にするため、UserDefaultsを取得するメソッドを分離
    func getUserDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    /// カテゴリの初期化
    private func setupCategories() {
        let allActions = Array(T.allCases)
        
        /// カテゴリ分けのロジック（実際のアプリに合わせて調整が必要）
        categorizedActions[.all] = allActions
        
        /// 以下は例として、rawValueの値に基づいて分類（実際のアプリに合わせて調整が必要）
        if T.self == ChildActionType.self {
            let positive: [T] = [
                ChildActionType.laughing, 
                ChildActionType.helping,
                ChildActionType.sharing,
                ChildActionType.concentrating,
                ChildActionType.beingKind,
                ChildActionType.apologizing,
                ChildActionType.complimenting
            ].compactMap { $0 as? T }
            
            let negative: [T] = [
                ChildActionType.crying,
                ChildActionType.screaming,
                ChildActionType.throwingThings,
                ChildActionType.hitting,
                ChildActionType.sulking,
                ChildActionType.ignoring,
                ChildActionType.refusing,
                ChildActionType.breakingRules,
                ChildActionType.teasing,
                ChildActionType.lying,
                ChildActionType.notCleaningUp,
                ChildActionType.interrupting
            ].compactMap { $0 as? T }
            
            categorizedActions[.positive] = positive
            categorizedActions[.negative] = negative
            categorizedActions[.neutral] = allActions.filter { !positive.contains($0) && !negative.contains($0) }
        } else if T.self == ParentActionType.self {
            let positive: [T] = [
                ParentActionType.hugging,
                ParentActionType.comforting,
                ParentActionType.praising,
                ParentActionType.encouraging,
                ParentActionType.listening,
                ParentActionType.appreciating,
                ParentActionType.supporting,
                ParentActionType.playingTogether
            ].compactMap { $0 as? T }
            
            let negative: [T] = [
                ParentActionType.scolding,
                ParentActionType.ignoring,
                ParentActionType.gettingAngry,
                ParentActionType.sighing,
                ParentActionType.forcing,
                ParentActionType.threatening,
                ParentActionType.punishing,
                ParentActionType.walkingAway,
                ParentActionType.gettingSilent
            ].compactMap { $0 as? T }
            
            categorizedActions[.positive] = positive
            categorizedActions[.negative] = negative
            categorizedActions[.neutral] = allActions.filter { !positive.contains($0) && !negative.contains($0) }
        }
        
        categorizedActions[.recent] = []
    }
    
    /// 最近使用した行動を保存
    private func saveRecentActions() {
        if let encoded = try? JSONEncoder().encode(recentActions.map { $0.rawValue }) {
            getUserDefaults().set(encoded, forKey: "recent\(T.self)Actions")
        }
    }
    
    /// 最近使用した行動をロード
    private func loadRecentActions() {
        if let data = getUserDefaults().data(forKey: "recent\(T.self)Actions"),
           let decodedRawValues = try? JSONDecoder().decode([Int].self, from: data) {
            recentActions = decodedRawValues.compactMap { rawValue in
                T.allCases.first { $0.rawValue == rawValue }
            }
        }
    }
    
    /// 行動を選択状態に追加
    func insert(_ action: T) {
        selectedActions.insert(action)
        updateRecentActions(action)
    }
    
    /// 行動を選択状態から削除
    func remove(_ action: T) {
        selectedActions.remove(action)
    }
    
    /// 行動の選択状態を切り替え
    func toggle(_ action: T) {
        if selectedActions.contains(action) {
            remove(action)
        } else {
            insert(action)
        }
    }
    
    /// 行動が選択されているかチェック
    func contains(_ action: T) -> Bool {
        return selectedActions.contains(action)
    }
    
    /// 最近使用した行動を更新
    private func updateRecentActions(_ action: T) {
        /// 同じアクションが既にある場合は削除
        recentActions.removeAll { $0.id == action.id }
        
        /// 先頭に追加
        recentActions.insert(action, at: 0)
        
        /// 最大数を超えたら削除
        if recentActions.count > maxRecentActions {
            recentActions = Array(recentActions.prefix(maxRecentActions))
        }
        
        /// 永続化
        saveRecentActions()
    }
    
    /// 現在の条件に基づいてフィルタリングされた行動リストを取得
    func filteredActions() -> [T] {
        var actionsToShow: [T] = []
        
        /// カテゴリで絞り込む
        if selectedCategory == .recent {
            actionsToShow = recentActions
        } else {
            actionsToShow = categorizedActions[selectedCategory] ?? []
        }
        
        /// 検索テキストがある場合はさらに絞り込む
        if !searchText.isEmpty {
            actionsToShow = actionsToShow.filter {
                $0.displayText.lowercased().contains(searchText.lowercased())
            }
        }
        
        return actionsToShow
    }
}

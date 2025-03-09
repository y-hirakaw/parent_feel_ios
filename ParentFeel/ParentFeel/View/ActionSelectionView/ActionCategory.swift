import SwiftUI

/// ActionSelectionViewで使用されるカテゴリを表す列挙型です。
/// アクションを分類するために使用されます。
enum ActionCategory: String, CaseIterable, Identifiable {
    /// すべてのアクションを表示
    case all
    /// ポジティブなアクションを表示
    case positive
    /// ネガティブなアクションを表示
    case negative
    /// 中立的なアクションを表示
    case neutral
    /// 最近使用したアクションを表示
    case recent
    
    /// 識別子としてrawValueを使用
    var id: String { rawValue }
    
    /// カテゴリの表示テキストを取得
    var displayText: String {
        switch self {
        case .all:
            return String(localized: "すべて")
        case .positive:
            return String(localized: "ポジティブ")
        case .negative:
            return String(localized: "ネガティブ")
        case .neutral:
            return String(localized: "ニュートラル")
        case .recent:
            return String(localized: "最近使用")
        }
    }
}
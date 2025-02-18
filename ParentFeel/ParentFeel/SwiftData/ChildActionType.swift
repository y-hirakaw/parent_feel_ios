import Foundation

enum ChildActionType: Int, ActionType, CaseIterable, Identifiable, RawRepresentable, Codable {
    case crying          // 泣く
    case screaming       // 叫ぶ
    case throwingThings  // 物を投げる
    case hitting         // 叩く・蹴る
    case sulking         // すねる
    case ignoring        // 無視する
    case clinging        // 甘える
    case foolingAround   // ふざける
    case refusing        // 拒否する
    case runningAway     // 逃げる
    case arguing         // 言い返す
    case breakingRules   // ルールを破る
    case hiding          // 隠れる
    case gettingExcited  // 興奮する
    case teasing         // からかう
    case lying           // 嘘をつく
    case notCleaningUp   // 片付けをしない
    case interrupting    // 話を遮る
    case laughing        // 笑う
    case helping         // 手伝う
    case sharing         // 分け合う
    case concentrating   // 集中する
    case beingKind       // 優しくする
    case apologizing     // 謝る
    case complimenting   // 褒める

    var id: String { String(self.rawValue) }

    var displayText: String {
        switch self {
        case .crying: return String(localized: "泣く")
        case .screaming: return String(localized: "叫ぶ")
        case .throwingThings: return String(localized: "物を投げる")
        case .hitting: return String(localized: "叩く・蹴る")
        case .sulking: return String(localized: "すねる")
        case .ignoring: return String(localized: "無視する")
        case .clinging: return String(localized: "甘える")
        case .foolingAround: return String(localized: "ふざける")
        case .refusing: return String(localized: "拒否する")
        case .runningAway: return String(localized: "逃げる")
        case .arguing: return String(localized: "言い返す")
        case .breakingRules: return String(localized: "ルールを破る")
        case .hiding: return String(localized: "隠れる")
        case .gettingExcited: return String(localized: "興奮する")
        case .teasing: return String(localized: "からかう")
        case .lying: return String(localized: "嘘をつく")
        case .notCleaningUp: return String(localized: "片付けをしない")
        case .interrupting: return String(localized: "話を遮る")
        case .laughing: return String(localized: "笑う")
        case .helping: return String(localized: "手伝う")
        case .sharing: return String(localized: "分け合う")
        case .concentrating: return String(localized: "集中する")
        case .beingKind: return String(localized: "優しくする")
        case .apologizing: return String(localized: "謝る")
        case .complimenting: return String(localized: "褒める")
        }
    }
}

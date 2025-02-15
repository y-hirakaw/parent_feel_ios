import Foundation

enum ChildActionType: Int, CaseIterable, Identifiable, RawRepresentable, Codable {
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

    var id: String { String(self.rawValue) }

    var displayText: String {
        switch self {
        case .crying: return "泣く"
        case .screaming: return "叫ぶ"
        case .throwingThings: return "物を投げる"
        case .hitting: return "叩く・蹴る"
        case .sulking: return "すねる"
        case .ignoring: return "無視する"
        case .clinging: return "甘える"
        case .foolingAround: return "ふざける"
        case .refusing: return "拒否する"
        case .runningAway: return "逃げる"
        case .arguing: return "言い返す"
        case .breakingRules: return "ルールを破る"
        case .hiding: return "隠れる"
        case .gettingExcited: return "興奮する"
        case .teasing: return "からかう"
        case .lying: return "嘘をつく"
        case .notCleaningUp: return "片付けをしない"
        case .interrupting: return "話を遮る"
        }
    }
}

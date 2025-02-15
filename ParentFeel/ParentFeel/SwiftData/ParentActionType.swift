import Foundation

enum ParentActionType: Int, CaseIterable, Identifiable, RawRepresentable, Codable {
    case scolding       // 叱る
    case ignoring       // 無視する
    case explaining     // 説明する
    case hugging        // 抱きしめる
    case gettingAngry   // 怒る
    case sighing        // ため息をつく
    case forcing        // 強制する
    case comforting     // なだめる
    case givingIn       // 言うことを聞く
    case threatening    // 脅す
    case punishing      // 罰を与える
    case negotiating    // 交渉する
    case praising       // 褒める
    case apologizing    // 謝る
    case walkingAway    // 立ち去る
    case changingTopic  // 話題を変える
    case consulting     // 誰かに相談する
    case gettingSilent  // 黙る

    var id: String { String(self.rawValue) }

    var displayText: String {
        switch self {
        case .scolding: return "叱る"
        case .ignoring: return "無視する"
        case .explaining: return "説明する"
        case .hugging: return "抱きしめる"
        case .gettingAngry: return "怒る"
        case .sighing: return "ため息をつく"
        case .forcing: return "強制する"
        case .comforting: return "なだめる"
        case .givingIn: return "言うことを聞く"
        case .threatening: return "脅す"
        case .punishing: return "罰を与える"
        case .negotiating: return "交渉する"
        case .praising: return "褒める"
        case .apologizing: return "謝る"
        case .walkingAway: return "立ち去る"
        case .changingTopic: return "話題を変える"
        case .consulting: return "誰かに相談する"
        case .gettingSilent: return "黙る"
        }
    }
}

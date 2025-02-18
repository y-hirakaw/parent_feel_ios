import Foundation

enum ParentActionType: Int, ActionType, CaseIterable, Identifiable, RawRepresentable, Codable {
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
    case encouraging      // 励ます
    case listening        // 話を聞く
    case appreciating     // 感謝を伝える
    case supporting       // サポートする
    case playingTogether  // 一緒に遊ぶ

    var id: String { String(self.rawValue) }

    var displayText: String {
        switch self {
        case .scolding: return String(localized: "叱る")
        case .ignoring: return String(localized: "無視する")
        case .explaining: return String(localized: "説明する")
        case .hugging: return String(localized: "抱きしめる")
        case .gettingAngry: return String(localized: "怒る")
        case .sighing: return String(localized: "ため息をつく")
        case .forcing: return String(localized: "強制する")
        case .comforting: return String(localized: "なだめる")
        case .givingIn: return String(localized: "言うことを聞く")
        case .threatening: return String(localized: "脅す")
        case .punishing: return String(localized: "罰を与える")
        case .negotiating: return String(localized: "交渉する")
        case .praising: return String(localized: "褒める")
        case .apologizing: return String(localized: "謝る")
        case .walkingAway: return String(localized: "立ち去る")
        case .changingTopic: return String(localized: "話題を変える")
        case .consulting: return String(localized: "誰かに相談する")
        case .gettingSilent: return String(localized: "黙る")
        case .encouraging: return String(localized: "励ます")
        case .listening: return String(localized: "話を聞く")
        case .appreciating: return String(localized: "感謝を伝える")
        case .supporting: return String(localized: "サポートする")
        case .playingTogether: return String(localized: "一緒に遊ぶ")
        }
    }
}

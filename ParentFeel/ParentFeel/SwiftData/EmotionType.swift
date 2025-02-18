import Foundation

enum EmotionCategory: Int, CaseIterable, Identifiable, RawRepresentable, Codable {
    case positive
    case negative
    case protective
    case selfReflective
    case anticipatory
    case complex

    var id: Int { self.rawValue }

    var emotions: [EmotionType] {
        switch self {
        case .positive:
            return [.affection, .joy, .pride]
        case .negative:
            return [.anger, .sadness, .disappointment]
        case .protective:
            return [.anxiety, .worry, .fear]
        case .selfReflective:
            return [.guilt, .regret, .impatience]
        case .anticipatory:
            return [.hope, .expectation, .excitement]
        case .complex:
            return [.jealousy, .confusion, .loneliness]
        }
    }

    var displayText: String {
        switch self {
        case .positive:
            return String(localized: "肯定的感情")
        case .negative:
            return String(localized: "否定的感情")
        case .protective:
            return String(localized: "保護的感情")
        case .selfReflective:
            return String(localized: "自己反省的感情")
        case .anticipatory:
            return String(localized: "期待的感情")
        case .complex:
            return String(localized: "複雑な感情")
        }
    }
}

enum EmotionType: Int, CaseIterable, Identifiable, RawRepresentable, Codable {
    // Positive emotions
    case affection
    case joy
    case pride

    // Negative emotions
    case anger
    case sadness
    case disappointment

    // Protective emotions
    case anxiety
    case worry
    case fear

    // Self-reflective emotions
    case guilt
    case regret
    case impatience

    // Anticipatory emotions
    case hope
    case expectation
    case excitement

    // Complex emotions
    case jealousy
    case confusion
    case loneliness

    var id: String { String(self.rawValue) }

    var displayText: String {
        switch self {
        case .affection:
            return String(localized: "愛情")
        case .joy:
            return String(localized: "喜び")
        case .pride:
            return String(localized: "誇り")
        case .anger:
            return String(localized: "怒り")
        case .sadness:
            return String(localized: "悲しみ")
        case .disappointment:
            return String(localized: "失望")
        case .anxiety:
            return String(localized: "不安")
        case .worry:
            return String(localized: "心配")
        case .fear:
            return String(localized: "恐れ")
        case .guilt:
            return String(localized: "罪悪感")
        case .regret:
            return String(localized: "後悔")
        case .impatience:
            return String(localized: "焦り")
        case .hope:
            return String(localized: "希望")
        case .expectation:
            return String(localized: "期待")
        case .excitement:
            return String(localized: "興奮")
        case .jealousy:
            return String(localized: "嫉妬")
        case .confusion:
            return String(localized: "戸惑い")
        case .loneliness:
            return String(localized: "寂しさ")
        }
    }

    var emoji: String {
        switch self {
        case .affection:
            return "❤️"
        case .joy:
            return "😊"
        case .pride:
            return "😌"
        case .anger:
            return "😠"
        case .sadness:
            return "😢"
        case .disappointment:
            return "😞"
        case .anxiety:
            return "😟"
        case .worry:
            return "😰"
        case .fear:
            return "😨"
        case .guilt:
            return "😔"
        case .regret:
            return "😣"
        case .impatience:
            return "😤"
        case .hope:
            return "🤞"
        case .expectation:
            return "😯"
        case .excitement:
            return "😃"
        case .jealousy:
            return "😒"
        case .confusion:
            return "😕"
        case .loneliness:
            return "😞"
        }
    }
}

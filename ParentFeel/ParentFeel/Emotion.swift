import SwiftData
import Foundation

enum EmotionCategory: String, CaseIterable, Identifiable, RawRepresentable, Codable {
    case positive = "肯定的感情"
    case negative = "否定的感情"
    case protective = "保護的感情"
    case selfReflective = "自己反省的感情"
    case anticipatory = "期待的感情"
    case complex = "複雑な感情"

    var id: String { self.rawValue }

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
            return "愛情"
        case .joy:
            return "喜び"
        case .pride:
            return "誇り"
        case .anger:
            return "怒り"
        case .sadness:
            return "悲しみ"
        case .disappointment:
            return "失望"
        case .anxiety:
            return "不安"
        case .worry:
            return "心配"
        case .fear:
            return "恐れ"
        case .guilt:
            return "罪悪感"
        case .regret:
            return "後悔"
        case .impatience:
            return "焦り"
        case .hope:
            return "希望"
        case .expectation:
            return "期待"
        case .excitement:
            return "興奮"
        case .jealousy:
            return "嫉妬"
        case .confusion:
            return "戸惑い"
        case .loneliness:
            return "寂しさ"
        }
    }
}

@Model
final class Emotion: Identifiable {
    var id: UUID
    var emotionType: EmotionType
    var childActions: [String]
    var parentActions: [String]
    var notes: String
    var timestamp: Date

    init(emotionType: EmotionType, childActions: [String], parentActions: [String], notes: String) {
        self.id = UUID()
        self.emotionType = emotionType
        self.childActions = childActions
        self.parentActions = parentActions
        self.notes = notes
        self.timestamp = Date()
    }
}

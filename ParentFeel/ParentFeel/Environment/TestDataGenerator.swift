import SwiftData
import Foundation

#if DEBUG
class TestDataGenerator {
    
    static func generateTestData(context: ModelContext) {
        // 既存のデータがある場合は追加しない
        let descriptor = FetchDescriptor<Emotion>()
        let existingEmotions = try? context.fetch(descriptor)
        if let emotions = existingEmotions, !emotions.isEmpty {
            print(String(localized: "既存のデータが見つかりました。テストデータの生成をスキップします。"))
            return
        }
        
        print(String(localized: "テストデータを生成中..."))
        
        let calendar = Calendar.current
        let today = Date()
        
        // 過去30日間のテストデータを生成
        for dayOffset in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            
            // 1日あたり1-3個の感情データを生成
            let emotionCount = Int.random(in: 1...3)
            
            for _ in 0..<emotionCount {
                let emotion = createRandomEmotion(for: date)
                context.insert(emotion)
            }
        }
        
        // 過去3ヶ月のより少ないデータ（週に1-2回程度）
        for weekOffset in 5..<12 {
            guard let weekStart = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: today) else { continue }
            
            let emotionCount = Int.random(in: 1...2)
            for dayInWeek in 0..<emotionCount {
                guard let date = calendar.date(byAdding: .day, value: dayInWeek * 3, to: weekStart) else { continue }
                let emotion = createRandomEmotion(for: date)
                context.insert(emotion)
            }
        }
        
        do {
            try context.save()
            print(String(localized: "テストデータの生成が完了しました。"))
        } catch {
            print(String(localized: "テストデータの保存に失敗しました: \(error)"))
        }
    }
    
    private static func createRandomEmotion(for date: Date) -> Emotion {
        // ランダムな感情タイプを選択
        let emotionType = EmotionType.allCases.randomElement() ?? .joy
        
        // 感情タイプに応じて適切な行動パターンを選択
        let (childActions, parentActions) = generateRealisticActions(for: emotionType)
        
        // ランダムな時間を追加（その日の8:00-22:00の間）
        let randomHour = Int.random(in: 8...22)
        let randomMinute = Int.random(in: 0...59)
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        dateComponents.hour = randomHour
        dateComponents.minute = randomMinute
        let finalDate = Calendar.current.date(from: dateComponents) ?? date
        
        // 自己振り返りデータを生成
        let (pastExperience, pastExperienceFeeling, pastExperienceSentiment, desiredResponse) = generateSelfReflectionData(for: emotionType)
        
        let emotion = Emotion(
            emotionType: emotionType,
            childActions: childActions,
            parentActions: parentActions,
            notes: generateRandomNote(for: emotionType),
            pastExperience: pastExperience,
            pastExperienceFeeling: pastExperienceFeeling,
            pastExperienceSentiment: pastExperienceSentiment,
            desiredResponse: desiredResponse
        )
        
        emotion.timestamp = finalDate
        return emotion
    }
    
    private static func generateRealisticActions(for emotionType: EmotionType) -> ([ChildActionType], [ParentActionType]) {
        let childActions: [ChildActionType]
        let parentActions: [ParentActionType]
        
        switch emotionType {
        case .anger:
            childActions = [.crying, .screaming, .throwingThings, .hitting].shuffled().prefix(Int.random(in: 1...2)).map { $0 }
            parentActions = [.scolding, .gettingAngry, .sighing, .walkingAway].shuffled().prefix(Int.random(in: 1...2)).map { $0 }
            
        case .joy, .affection, .pride:
            childActions = [.laughing, .helping, .sharing, .beingKind].shuffled().prefix(Int.random(in: 1...2)).map { $0 }
            parentActions = [.praising, .hugging, .encouraging, .playingTogether].shuffled().prefix(Int.random(in: 1...2)).map { $0 }
            
        case .anxiety, .worry, .fear:
            childActions = [.crying, .clinging, .hiding, .runningAway].shuffled().prefix(Int.random(in: 1...2)).map { $0 }
            parentActions = [.comforting, .hugging, .explaining, .listening].shuffled().prefix(Int.random(in: 1...2)).map { $0 }
            
        case .guilt, .regret:
            childActions = [.sulking, .crying, .apologizing].shuffled().prefix(Int.random(in: 1...2)).map { $0 }
            parentActions = [.apologizing, .explaining, .hugging, .listening].shuffled().prefix(Int.random(in: 1...2)).map { $0 }
            
        case .sadness, .disappointment:
            childActions = [.crying, .sulking, .clinging].shuffled().prefix(Int.random(in: 1...2)).map { $0 }
            parentActions = [.comforting, .hugging, .listening, .supporting].shuffled().prefix(Int.random(in: 1...2)).map { $0 }
            
        default:
            childActions = ChildActionType.allCases.shuffled().prefix(Int.random(in: 1...2)).map { $0 }
            parentActions = ParentActionType.allCases.shuffled().prefix(Int.random(in: 1...2)).map { $0 }
        }
        
        return (childActions, parentActions)
    }
    
    private static func generateSelfReflectionData(for emotionType: EmotionType) -> (String, String, String, String) {
        let pastExperiences = [
            "小さい頃、同じような状況で親に叱られた経験がある",
            "自分も子どもの頃、同じことをして困らせていた",
            "親が忙しいときに構ってもらえなかった記憶がある",
            "兄弟と比較されて悲しい思いをした",
            "頑張ったのに認めてもらえなかった経験がある"
        ]
        
        let feelings = [
            "その時は理不尽だと感じていた",
            "寂しくて仕方なかった",
            "もっと愛情を感じたかった",
            "認めてもらいたかった",
            "安心感が欲しかった"
        ]
        
        let sentiments = ["positive", "negative"].randomElement() ?? "negative"
        
        let desiredResponses = [
            "まず子どもの気持ちを聞いてあげたい",
            "冷静になってから話し合いたい",
            "子どもの立場に立って考えてみたい",
            "もっと愛情を表現したい",
            "一緒に解決策を考えたい"
        ]
        
        // 30%の確率で自己振り返りデータを含める
        if Int.random(in: 1...10) <= 3 {
            return (
                pastExperiences.randomElement() ?? "",
                feelings.randomElement() ?? "",
                sentiments,
                desiredResponses.randomElement() ?? ""
            )
        } else {
            return ("", "", "", "")
        }
    }
    
    private static func generateRandomNote(for emotionType: EmotionType) -> String {
        let notes = [
            "朝から機嫌が悪かった",
            "保育園でのことが影響していそう",
            "疲れているときに起きがち",
            "最近よく見られる行動",
            "成長の一環だと思いたい",
            "対応を見直す必要がある",
            "良い変化が見られた",
            "前回より上手に対応できた",
            "子どもなりに頑張っていた",
            "親子で良い時間を過ごせた"
        ]
        
        // 50%の確率でメモを含める
        if Bool.random() {
            return notes.randomElement() ?? ""
        } else {
            return ""
        }
    }
}
#endif
import SwiftUI
import SwiftData
import Charts

struct EmotionTrendData: Identifiable {
    let id = UUID()
    let date: Date
    let emotionType: EmotionType
    let count: Int
}

struct EmotionCategoryTrendData: Identifiable {
    let id = UUID()
    let date: Date
    let category: EmotionCategory
    let count: Int
}

struct EmotionCategoryData: Identifiable {
    let id = UUID()
    let category: EmotionCategory
    let count: Int
    let percentage: Double
}

struct ActionPatternData: Identifiable {
    let id = UUID()
    let childAction: ChildActionType
    let parentAction: ParentActionType
    let count: Int
}

enum AnalyticsTimeRange: String, CaseIterable {
    case week = "week"
    case month = "month"
    case threeMonths = "threeMonths"
    case year = "year"
    
    var displayText: String {
        switch self {
        case .week: return String(localized: "1週間")
        case .month: return String(localized: "1ヶ月")
        case .threeMonths: return String(localized: "3ヶ月")
        case .year: return String(localized: "1年")
        }
    }
    
    var days: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .threeMonths: return 90
        case .year: return 365
        }
    }
}

@MainActor
class AnalyticsViewState: ObservableObject {
    @Published var selectedTimeRange: AnalyticsTimeRange = .month
    @Published var emotionTrendData: [EmotionTrendData] = []
    @Published var emotionCategoryTrendData: [EmotionCategoryTrendData] = []
    @Published var emotionCategoryData: [EmotionCategoryData] = []
    @Published var actionPatternData: [ActionPatternData] = []
    @Published var totalEmotions: Int = 0
    @Published var mostFrequentEmotion: EmotionType?
    @Published var emotionStreak: Int = 0
    @Published var showDetailedTrend: Bool = false
    
    private var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        analyzeData()
    }
    
    func updateTimeRange(_ range: AnalyticsTimeRange) {
        selectedTimeRange = range
        analyzeData()
    }
    
    private func analyzeData() {
        guard let modelContext = modelContext else { return }
        
        let startDate = Calendar.current.date(byAdding: .day, value: -selectedTimeRange.days, to: Date()) ?? Date()
        
        do {
            let descriptor = FetchDescriptor<Emotion>(
                predicate: #Predicate<Emotion> { emotion in
                    emotion.timestamp >= startDate
                },
                sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
            )
            
            let emotions = try modelContext.fetch(descriptor)
            
            generateTrendData(from: emotions)
            generateCategoryTrendData(from: emotions)
            generateCategoryData(from: emotions)
            generateActionPatternData(from: emotions)
            calculateSummaryStats(from: emotions)
            
        } catch {
            print(String(localized: "データの取得に失敗しました: \(error)"))
        }
    }
    
    private func generateTrendData(from emotions: [Emotion]) {
        let calendar = Calendar.current
        var trendData: [EmotionTrendData] = []
        
        // 期間内の各日付でグループ化
        let groupedByDate = Dictionary(grouping: emotions) { emotion in
            calendar.startOfDay(for: emotion.timestamp)
        }
        
        // 各日付と感情タイプの組み合わせで集計
        for (date, dayEmotions) in groupedByDate {
            let emotionCounts = Dictionary(grouping: dayEmotions) { $0.emotionType }
            
            for (emotionType, emotionList) in emotionCounts {
                trendData.append(EmotionTrendData(
                    date: date,
                    emotionType: emotionType,
                    count: emotionList.count
                ))
            }
        }
        
        self.emotionTrendData = trendData.sorted { $0.date < $1.date }
    }
    
    private func generateCategoryTrendData(from emotions: [Emotion]) {
        let calendar = Calendar.current
        var categoryTrendData: [EmotionCategoryTrendData] = []
        
        // 期間内の各日付でグループ化
        let groupedByDate = Dictionary(grouping: emotions) { emotion in
            calendar.startOfDay(for: emotion.timestamp)
        }
        
        // 各日付でカテゴリ別に集計
        for (date, dayEmotions) in groupedByDate {
            // 感情をカテゴリにマッピング
            let categoryEmotions = dayEmotions.map { emotion in
                EmotionCategory.allCases.first { category in
                    category.emotions.contains(emotion.emotionType)
                } ?? .complex
            }
            
            // カテゴリ別にカウント
            let categoryCounts = Dictionary(grouping: categoryEmotions) { $0 }
            
            for (category, categoryList) in categoryCounts {
                categoryTrendData.append(EmotionCategoryTrendData(
                    date: date,
                    category: category,
                    count: categoryList.count
                ))
            }
        }
        
        self.emotionCategoryTrendData = categoryTrendData.sorted { $0.date < $1.date }
    }
    
    private func generateCategoryData(from emotions: [Emotion]) {
        let categoryGroups = Dictionary(grouping: emotions) { emotion in
            EmotionCategory.allCases.first { category in
                category.emotions.contains(emotion.emotionType)
            } ?? .complex
        }
        
        let totalCount = emotions.count
        
        self.emotionCategoryData = categoryGroups.map { (category, emotionList) in
            let count = emotionList.count
            let percentage = totalCount > 0 ? Double(count) / Double(totalCount) * 100 : 0
            
            return EmotionCategoryData(
                category: category,
                count: count,
                percentage: percentage
            )
        }.sorted { $0.count > $1.count }
    }
    
    private func generateActionPatternData(from emotions: [Emotion]) {
        var patterns: [String: Int] = [:]
        
        for emotion in emotions {
            for childAction in emotion.childActions {
                for parentAction in emotion.parentActions {
                    let key = "\(childAction.rawValue)-\(parentAction.rawValue)"
                    patterns[key, default: 0] += 1
                }
            }
        }
        
        // 上位10パターンのみ取得
        let topPatterns = patterns.sorted { $0.value > $1.value }.prefix(10)
        
        self.actionPatternData = topPatterns.compactMap { (key, count) in
            let components = key.split(separator: "-")
            guard components.count == 2,
                  let childActionRaw = Int(components[0]),
                  let parentActionRaw = Int(components[1]),
                  let childAction = ChildActionType(rawValue: childActionRaw),
                  let parentAction = ParentActionType(rawValue: parentActionRaw) else {
                return nil
            }
            
            return ActionPatternData(
                childAction: childAction,
                parentAction: parentAction,
                count: count
            )
        }
    }
    
    private func calculateSummaryStats(from emotions: [Emotion]) {
        self.totalEmotions = emotions.count
        
        // 最も頻繁な感情を計算
        let emotionCounts = Dictionary(grouping: emotions) { $0.emotionType }
        self.mostFrequentEmotion = emotionCounts.max { $0.value.count < $1.value.count }?.key
        
        // 連続記録日数を計算
        self.emotionStreak = calculateEmotionStreak(from: emotions)
    }
    
    private func calculateEmotionStreak(from emotions: [Emotion]) -> Int {
        let calendar = Calendar.current
        let sortedEmotions = emotions.sorted { $0.timestamp > $1.timestamp }
        
        guard !sortedEmotions.isEmpty else { return 0 }
        
        var streak = 1
        var currentDate = calendar.startOfDay(for: sortedEmotions[0].timestamp)
        
        for i in 1..<sortedEmotions.count {
            let emotionDate = calendar.startOfDay(for: sortedEmotions[i].timestamp)
            let daysDifference = calendar.dateComponents([.day], from: emotionDate, to: currentDate).day ?? 0
            
            if daysDifference == 1 {
                streak += 1
                currentDate = emotionDate
            } else if daysDifference > 1 {
                break
            }
        }
        
        return streak
    }
}
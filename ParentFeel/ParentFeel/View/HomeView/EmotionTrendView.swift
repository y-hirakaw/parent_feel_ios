import SwiftUI
import SwiftData
import Charts

struct EmotionTrendView: View {
    @StateObject private var viewState = EmotionTrendViewState()
    @Query(sort: \Emotion.timestamp) private var emotions: [Emotion]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                EmotionGraphView(emotions: emotions)
                    .padding()
            }
            .navigationTitle(String(localized: "感情トレンド"))
        }
    }
}

struct EmotionGraphView: View {
    let emotions: [Emotion]
    @State private var timeRange: TimeRangeFilter = .week
    
    enum TimeRangeFilter: String, CaseIterable, Identifiable {
        case week = "1週間"
        case month = "1ヶ月"
        case threeMonths = "3ヶ月"
        case all = "全期間"
        
        var id: String { self.rawValue }
        
        var localizedName: String {
            switch self {
            case .week:
                return String(localized: "1週間")
            case .month:
                return String(localized: "1ヶ月")
            case .threeMonths:
                return String(localized: "3ヶ月")
            case .all:
                return String(localized: "すべて")
            }
        }
    }
    
    var filteredEmotions: [Emotion] {
        let calendar = Calendar.current
        let now = Date()
        
        switch timeRange {
        case .week:
            guard let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now) else { return emotions }
            return emotions.filter { $0.timestamp >= oneWeekAgo }
        case .month:
            guard let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: now) else { return emotions }
            return emotions.filter { $0.timestamp >= oneMonthAgo }
        case .threeMonths:
            guard let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now) else { return emotions }
            return emotions.filter { $0.timestamp >= threeMonthsAgo }
        case .all:
            return emotions
        }
    }
    
    // 日付ごとの感情カテゴリをカウントするデータ構造
    struct DailyEmotionCount: Identifiable {
        var id = UUID()
        var date: Date
        var categoryCounts: [EmotionCategory: Int]
    }
    
    // フィルタリングされた感情から日ごとのデータを生成
    var dailyData: [DailyEmotionCount] {
        let calendar = Calendar.current
        var result: [Date: [EmotionCategory: Int]] = [:]
        
        // 日付の範囲を決定
        let dates = filteredEmotions.map { $0.timestamp }.sorted()
        guard let firstDate = dates.first, let lastDate = dates.last else { return [] }
        
        // 全ての日付を生成
        var currentDate = calendar.startOfDay(for: firstDate)
        let endDate = calendar.startOfDay(for: lastDate)
        
        while currentDate <= endDate {
            result[currentDate] = [:]
            for category in EmotionCategory.allCases {
                result[currentDate]?[category] = 0
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        // 感情をカウント
        for emotion in filteredEmotions {
            let dateKey = calendar.startOfDay(for: emotion.timestamp)
            
            for category in EmotionCategory.allCases where category.emotions.contains(emotion.emotionType) {
                if var categoryDict = result[dateKey] {
                    let currentCount = categoryDict[category] ?? 0
                    categoryDict[category] = currentCount + 1
                    result[dateKey] = categoryDict
                }
                break
            }
        }
        
        // 結果を配列に変換
        return result.map { DailyEmotionCount(date: $0.key, categoryCounts: $0.value) }.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        VStack {
            Picker(String(localized: "期間"), selection: $timeRange) {
                ForEach(TimeRangeFilter.allCases) { range in
                    Text(range.localizedName).tag(range)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)
            
            if filteredEmotions.isEmpty {
                ContentUnavailableView(
                    String(localized: "この期間の記録はありません"),
                    systemImage: "chart.bar",
                    description: Text(String(localized: "感情を記録すると、ここにトレンドが表示されます"))
                )
            } else {
                VStack(alignment: .leading) {
                    Text(String(localized: "感情カテゴリの推移"))
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    Chart(dailyData) { dayData in
                        ForEach(EmotionCategory.allCases) { category in
                            let count = dayData.categoryCounts[category] ?? 0
                            if count > 0 {
                                BarMark(
                                    x: .value(String(localized: "日付"), dayData.date),
                                    y: .value(String(localized: "回数"), count)
                                )
                                .foregroundStyle(by: .value(String(localized: "カテゴリー"), category.displayText))
                            }
                        }
                    }
                    .chartForegroundStyleScale(domain: EmotionCategory.allCases.map { $0.displayText })
                    .chartLegend(position: .bottom, alignment: .center)
                    .frame(height: 250)
                    .id("categoryChart-\(timeRange)")
                }
                
                Divider().padding(.vertical)
                
                VStack(alignment: .leading) {
                    Text(String(localized: "感情の分布"))
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    let emotionCounts = getEmotionTypeCounts()
                    Chart(emotionCounts.sorted { $0.count > $1.count }) { item in
                        SectorMark(
                            angle: .value(String(localized: "回数"), item.count),
                            innerRadius: .ratio(0.5),
                            angularInset: 1.5
                        )
                        .foregroundStyle(by: .value(String(localized: "感情"), item.type.displayText))
                        .annotation(position: .overlay) {
                            Text("\(item.type.emoji)")
                                .font(.system(size: 14))
                        }
                    }
                    .chartLegend(position: .bottom)
                    .frame(height: 250)
                    .id("distributionChart-\(timeRange)")
                }
            }
        }
    }
    
    // 感情タイプごとのカウントを計算
    private func getEmotionTypeCounts() -> [EmotionTypeCount] {
        var counts: [EmotionType: Int] = [:]
        
        for emotion in filteredEmotions {
            counts[emotion.emotionType, default: 0] += 1
        }
        
        return counts.map { EmotionTypeCount(type: $0.key, count: $0.value) }
    }
    
    struct EmotionTypeCount: Identifiable {
        let id = UUID()
        let type: EmotionType
        let count: Int
    }
}

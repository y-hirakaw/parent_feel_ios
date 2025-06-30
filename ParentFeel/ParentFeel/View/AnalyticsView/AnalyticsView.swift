import SwiftUI
import SwiftData
import Charts

struct AnalyticsView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewState = AnalyticsViewState()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 期間選択
                    timeRangeSelector
                    
                    // サマリーカード
                    summaryCards
                    
                    // 感情トレンドグラフ
                    emotionTrendChart
                    
                    // 感情カテゴリ分布
                    emotionCategoryChart
                    
                    // 行動パターン分析
                    actionPatternList
                }
                .padding()
            }
            .navigationTitle(String(localized: "感情分析"))
            .onAppear {
                viewState.setModelContext(modelContext)
            }
        }
    }
    
    private var timeRangeSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "期間選択"))
                .font(.headline)
                .foregroundColor(.secondary)
            
            Picker(String(localized: "期間"), selection: $viewState.selectedTimeRange) {
                ForEach(AnalyticsTimeRange.allCases, id: \.self) { range in
                    Text(range.displayText).tag(range)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: viewState.selectedTimeRange) { newRange in
                viewState.updateTimeRange(newRange)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.05))
        )
    }
    
    private var summaryCards: some View {
        HStack(spacing: 16) {
            SummaryCard(
                title: String(localized: "記録数"),
                value: "\(viewState.totalEmotions)",
                icon: "heart.fill",
                color: .blue
            )
            
            SummaryCard(
                title: String(localized: "連続記録"),
                value: "\(viewState.emotionStreak)\(String(localized: "日"))",
                icon: "flame.fill",
                color: .orange
            )
            
            if let mostFrequent = viewState.mostFrequentEmotion {
                SummaryCard(
                    title: String(localized: "最多感情"),
                    value: mostFrequent.emoji,
                    icon: "chart.bar.fill",
                    color: .green
                )
            }
        }
    }
    
    private var emotionTrendChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(String(localized: "感情の推移"))
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewState.showDetailedTrend.toggle()
                    }
                }) {
                    Text(viewState.showDetailedTrend ? String(localized: "カテゴリ表示") : String(localized: "詳細表示"))
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            if viewState.showDetailedTrend {
                // 詳細表示（個別の感情タイプ）
                if !viewState.emotionTrendData.isEmpty {
                    Chart(viewState.emotionTrendData) { data in
                        LineMark(
                            x: .value("日付", data.date),
                            y: .value("回数", data.count)
                        )
                        .foregroundStyle(by: .value("感情", data.emotionType.displayText))
                        .symbol(by: .value("感情", data.emotionType.displayText))
                    }
                    .frame(height: 200)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.month().day())
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                        }
                    }
                    .chartLegend(.hidden) // 詳細表示では凡例を非表示
                } else {
                    Text(String(localized: "データがありません"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            } else {
                // カテゴリ別表示（見やすい）
                if !viewState.emotionCategoryTrendData.isEmpty && viewState.emotionCategoryTrendData.count > 0 {
                    Chart(viewState.emotionCategoryTrendData) { data in
                        LineMark(
                            x: .value("日付", data.date),
                            y: .value("回数", data.count)
                        )
                        .foregroundStyle(colorForCategory(data.category))
                        .lineStyle(StrokeStyle(lineWidth: 3))
                    }
                    .frame(height: 200)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.month().day())
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                        }
                    }
                } else {
                    Text(String(localized: "データがありません"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.05))
        )
    }
    
    private var emotionCategoryChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(String(localized: "感情カテゴリ分布"))
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if !viewState.emotionCategoryData.isEmpty {
                Chart(viewState.emotionCategoryData) { data in
                    SectorMark(
                        angle: .value("割合", data.count),
                        innerRadius: .ratio(0.4),
                        outerRadius: .ratio(0.8)
                    )
                    .foregroundStyle(by: .value("カテゴリ", data.category.displayText))
                    .cornerRadius(4)
                }
                .frame(height: 200)
                .chartLegend(position: .bottom, alignment: .center)
                
                // 詳細データ表示
                VStack(spacing: 8) {
                    ForEach(viewState.emotionCategoryData) { data in
                        HStack {
                            Text(data.category.displayText)
                                .font(.subheadline)
                            Spacer()
                            Text("\(data.count)\(String(localized: "回")) (\(data.percentage, specifier: "%.1f")%)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.top, 8)
            } else {
                Text("データがありません")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.05))
        )
    }
    
    private var actionPatternList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(String(localized: "よくある行動パターン"))
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if !viewState.actionPatternData.isEmpty {
                VStack(spacing: 8) {
                    ForEach(viewState.actionPatternData) { pattern in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(String(localized: "子ども")): \(pattern.childAction.displayText)")
                                    .font(.subheadline)
                                Text("\(String(localized: "親")): \(pattern.parentAction.displayText)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("\(pattern.count)\(String(localized: "回"))")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.05))
                        )
                    }
                }
            } else {
                Text("データがありません")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 32)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.05))
        )
    }
    
    private func colorForCategory(_ category: EmotionCategory) -> Color {
        switch category {
        case .positive:
            return .green
        case .negative:
            return .red
        case .protective:
            return .orange
        case .selfReflective:
            return .purple
        case .anticipatory:
            return .blue
        case .complex:
            return .gray
        }
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

#Preview {
    AnalyticsView()
        .modelContainer(for: Emotion.self, inMemory: true)
}
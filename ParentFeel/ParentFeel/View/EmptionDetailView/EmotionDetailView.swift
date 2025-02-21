import SwiftUI

struct EmotionDetailView: View {
    @StateObject var viewState: EmotionDetailViewState
    @Binding var path: NavigationPath

    init(emotion: Emotion, path: Binding<NavigationPath>) {
        self._viewState = StateObject(wrappedValue: EmotionDetailViewState(emotion: emotion))
        self._path = path
    }

    var body: some View {
        Group {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    detailRow(title: String(localized: "起きた感情"), content: viewState.emotionTypeText)
                    detailRow(title: String(localized: "子どもの行動"), content: viewState.childActionsText)
                    detailRow(title: String(localized: "自分の行動"), content: viewState.parentActionsText)
                    detailRow(title: String(localized: "メモ"), content: viewState.notesText, multiline: true)
                    detailRow(title: String(localized: "保存時間"), content: viewState.timestampText)
                }
                .padding()
            }
            .navigationTitle("感情詳細")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(value: Screen.input(viewState.emotion)) {
                        Text("編集")
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func detailRow(title: String, content: String, multiline: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(content)
                .foregroundColor(.primary)
                .multilineTextAlignment(multiline ? .leading : .trailing)
        }
        .padding(.vertical, 8)
        Divider()
    }
}

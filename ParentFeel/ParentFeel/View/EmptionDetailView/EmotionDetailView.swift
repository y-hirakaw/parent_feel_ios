import SwiftUI

struct EmotionDetailView: View {
    @StateObject var viewState: EmotionDetailViewState
    @Binding var path: NavigationPath

    init(emotion: Emotion, path: Binding<NavigationPath>) {
        self._viewState = StateObject(wrappedValue: EmotionDetailViewState(emotion: emotion))
        self._path = path
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(viewState.emotion.emotionType.emoji)
                        .font(.system(size: 40))
                        .padding(16)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.8))
                                .shadow(color: .black.opacity(0.1), radius: 8)
                        )
                    
                    detailRow(
                        title: String(localized: "起きた感情"),
                        content: viewState.emotionTypeText,
                        systemImage: "heart.fill"
                    )
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.1))
                )
                
                VStack(alignment: .leading, spacing: 16) {
                    detailRow(
                        title: String(localized: "子どもの行動"),
                        content: viewState.childActionsText,
                        systemImage: "person.2.fill"
                    )
                    
                    detailRow(
                        title: String(localized: "自分の行動"),
                        content: viewState.parentActionsText,
                        systemImage: "person.fill"
                    )
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.05))
                )
                
                VStack(alignment: .leading, spacing: 16) {
                    if !viewState.notesText.isEmpty {
                        detailRow(
                            title: String(localized: "メモ"),
                            content: viewState.notesText,
                            systemImage: "note.text",
                            multiline: true
                        )
                    }
                    
                    detailRow(
                        title: String(localized: "保存時間"),
                        content: viewState.timestampText,
                        systemImage: "clock.fill"
                    )
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.05))
                )
            }
            .padding()
        }
        .navigationTitle("感情詳細")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(value: Screen.input(viewState.emotion)) {
                    Text("編集")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
        }
    }

    @ViewBuilder
    private func detailRow(title: String, content: String, systemImage: String, multiline: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: multiline ? .leading : .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

import SwiftUI
import SwiftData

struct EmotionInputView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewState: EmotionInputViewState
    @Binding var path: NavigationPath

    init(emotion: Emotion? = nil, path: Binding<NavigationPath>) {
        self._viewState = StateObject(wrappedValue: EmotionInputViewState(emotion: emotion, path: path))
        self._path = path
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 24) {
                    // 感情選択セクション
                    VStack(spacing: 20) {
                        Text("起きた感情")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        ForEach(EmotionCategory.allCases) { category in
                            VStack(alignment: .leading, spacing: 12) {
                                Text(category.displayText)
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 16) {
                                        ForEach(category.emotions) { emotion in
                                            Button(action: {
                                                withAnimation(.spring(response: 0.3)) {
                                                    viewState.selectedEmotion = emotion
                                                }
                                            }) {
                                                VStack {
                                                    Text(emotion.emoji)
                                                        .font(.system(size: 40))
                                                        .frame(width: 70, height: 70)
                                                        .background(viewState.selectedEmotion == emotion ? Color.blue.opacity(0.8) : Color.gray.opacity(0.1))
                                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 16)
                                                                .stroke(viewState.selectedEmotion == emotion ? Color.blue : Color.clear, lineWidth: 3)
                                                        )
                                                        .shadow(color: viewState.selectedEmotion == emotion ? .blue.opacity(0.3) : .clear, radius: 8)

                                                    Text(emotion.displayText)
                                                        .font(.subheadline)
                                                        .foregroundColor(viewState.selectedEmotion == emotion ? .blue : .primary)
                                                }
                                                .padding(4) // 選択時の拡大に対するマージン
                                            }
                                            .scaleEffect(viewState.selectedEmotion == emotion ? 1.05 : 1.0)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    // 行動選択セクション
                    VStack(spacing: 24) {
                        // 子どもの行動選択
                        VStack(spacing: 12) {
                            Text("子どもの行動")
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button(action: {
                                viewState.isChildActionModalPresented = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text(viewState.selectedChildActions.isEmpty ? "選択する" : "変更する")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            if !viewState.selectedChildActions.isEmpty {
                                Text(viewState.selectedChildActions.map { $0.displayText }.joined(separator: "、"))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal)
                        
                        // 自分の行動選択
                        VStack(spacing: 12) {
                            Text("自分の行動")
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button(action: {
                                viewState.isParentActionModalPresented = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text(viewState.selectedParentActions.isEmpty ? "選択する" : "変更する")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            if !viewState.selectedParentActions.isEmpty {
                                Text(viewState.selectedParentActions.map { $0.displayText }.joined(separator: "、"))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // 自己振り返りセクション
                    VStack(spacing: 24) {
                        Text("自己振り返り")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        // 過去の経験
                        VStack(alignment: .leading, spacing: 12) {
                            Text("この感情を引き起こした自分の過去の経験は？")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ZStack(alignment: .topLeading) {
                                if viewState.pastExperience.isEmpty {
                                    Text("ここに過去の経験を入力")
                                        .foregroundColor(.secondary)
                                        .padding(.top, 8)
                                        .padding(.leading, 5)
                                }

                                TextEditor(text: $viewState.pastExperience)
                                    .frame(minHeight: 100)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding(.horizontal)
                        
                        // その経験の感じ方
                        VStack(alignment: .leading, spacing: 12) {
                            Text("その経験をどう感じていた？")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // ポジティブ/ネガティブの選択
                            HStack(spacing: 16) {
                                Button(action: {
                                    viewState.pastExperienceSentiment = "positive"
                                }) {
                                    HStack {
                                        Image(systemName: viewState.pastExperienceSentiment == "positive" ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(viewState.pastExperienceSentiment == "positive" ? .blue : .gray)
                                        Text("ポジティブ")
                                            .foregroundColor(viewState.pastExperienceSentiment == "positive" ? .blue : .primary)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(viewState.pastExperienceSentiment == "positive" ? Color.blue.opacity(0.1) : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                
                                Button(action: {
                                    viewState.pastExperienceSentiment = "negative"
                                }) {
                                    HStack {
                                        Image(systemName: viewState.pastExperienceSentiment == "negative" ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(viewState.pastExperienceSentiment == "negative" ? .blue : .gray)
                                        Text("ネガティブ")
                                            .foregroundColor(viewState.pastExperienceSentiment == "negative" ? .blue : .primary)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(viewState.pastExperienceSentiment == "negative" ? Color.blue.opacity(0.1) : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                
                                Spacer()
                            }
                            
                            ZStack(alignment: .topLeading) {
                                if viewState.pastExperienceFeeling.isEmpty {
                                    Text("ここに感じ方を入力")
                                        .foregroundColor(.secondary)
                                        .padding(.top, 8)
                                        .padding(.leading, 5)
                                }

                                TextEditor(text: $viewState.pastExperienceFeeling)
                                    .frame(minHeight: 100)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding(.horizontal)
                        
                        // 子どもへの対応方法
                        VStack(alignment: .leading, spacing: 12) {
                            Text("今の子どもにはどう対応したい？")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ZStack(alignment: .topLeading) {
                                if viewState.desiredResponse.isEmpty {
                                    Text("ここに対応方法を入力")
                                        .foregroundColor(.secondary)
                                        .padding(.top, 8)
                                        .padding(.leading, 5)
                                }

                                TextEditor(text: $viewState.desiredResponse)
                                    .frame(minHeight: 100)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)

                    // メモ欄
                    VStack(alignment: .leading, spacing: 12) {
                        Text("メモ")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ZStack(alignment: .topLeading) {
                            if viewState.notes.isEmpty {
                                Text("ここにメモを入力")
                                    .foregroundColor(.secondary)
                                    .padding(.top, 8)
                                    .padding(.leading, 5)
                            }

                            TextEditor(text: $viewState.notes)
                                .frame(minHeight: 100)
                                .scrollContentBackground(.hidden)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal)
                    
                    // 保存ボタンの下のスペース
                    Color.clear
                        .frame(height: 100) // 固定保存ボタンの高さ分のスペース
                }
            }
            
            // 固定保存ボタン
            VStack(spacing: 0) {
                Button(action: viewState.saveEmotion) {
                    Text("保存")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .blue.opacity(0.3), radius: 8, y: 4)
                }
                .padding(.horizontal)
                .padding(.vertical)
                .background(
                    Rectangle()
                        .fill(Color.white)
                        .ignoresSafeArea(edges: .bottom)
                        .shadow(color: .black.opacity(0.1), radius: 8, y: 8)
                )
            }
            .ignoresSafeArea(.keyboard)
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .navigationTitle("感情記録")
        .sheet(isPresented: $viewState.isChildActionModalPresented) {
            ActionSelectionView(selectedActions: $viewState.selectedChildActions)
        }
        .sheet(isPresented: $viewState.isParentActionModalPresented) {
            ActionSelectionView(selectedActions: $viewState.selectedParentActions)
        }
        .onAppear {
            viewState.setModelContext(modelContext)
        }
    }
}

#Preview {
    EmotionInputView(path: .constant(NavigationPath()))
        .modelContainer(for: Emotion.self, inMemory: true)
}

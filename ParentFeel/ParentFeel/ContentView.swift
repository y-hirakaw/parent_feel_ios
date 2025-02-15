import SwiftUI
import SwiftData
import Inject

struct ContentView: View {
    @ObserveInjection var inject

    @Environment(\.modelContext) private var modelContext
    @Query private var emotions: [Emotion]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(emotions) { emotion in
                    NavigationLink {
                        VStack(alignment: .leading) {
                            Text("Emotion: \(emotion.emotionType.displayText)")
                            Text("Child Actions: \(emotion.childActions.joined(separator: ", "))")
                            Text("Parent Actions: \(emotion.parentActions.joined(separator: ", "))")
                            Text("Notes: \(emotion.notes)")
                            Text("Timestamp: \(emotion.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        }
                    } label: {
                        HStack {
                            Text(emotion.emotionType.displayText)
                            Spacer()
                            Text(emotion.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
                    }
                }
                .onDelete(perform: deleteEmotions)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    NavigationLink(destination: EmotionInputView()) {
                        Label("Add Emotion", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an emotion")
        }
        .onAppear {
            print("Emotions: \(emotions)")
        }
        .enableInjection()
    }

    private func deleteEmotions(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(emotions[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Emotion.self, inMemory: true)
}

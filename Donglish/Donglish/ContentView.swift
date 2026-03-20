import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        CommuteModeView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Question.self, DrillSession.self, SessionAnswer.self], inMemory: true)
}

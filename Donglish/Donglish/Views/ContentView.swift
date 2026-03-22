import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var drillFlow = DrillFlow()
    @Query(filter: #Predicate<Question> { $0.statusRawValue == "new" },
           sort: \Question.level)
    private var newQuestions: [Question]
    @Query(filter: #Predicate<Question> {
        $0.statusRawValue == "reviewing"
    }) private var reviewQuestions: [Question]

    var body: some View {
        NavigationStack {
            Group {
                switch drillFlow.state {
                case .idle:
                    sessionStartView
                case .sessionComplete:
                    SessionSummaryView(drillFlow: drillFlow)
                default:
                    DrillActiveView(drillFlow: drillFlow)
                }
            }
            .navigationTitle("Commute Mode")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var sessionStartView: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "headphones")
                .font(.system(size: 80))
                .foregroundStyle(.secondary)

            Text("通勤モード")
                .font(.largeTitle.bold())

            Text("AirPods Proを装着して\nドリルを開始しましょう")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                Button {
                    Task { await startSession(type: .morning) }
                } label: {
                    Label("朝のドリルを開始", systemImage: "sunrise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button {
                    Task { await startSession(type: .evening) }
                } label: {
                    Label("帰りのドリルを開始", systemImage: "sunset")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
    }

    private func startSession(type: SessionType) async {
        let questions = SessionComposer.buildSessionQuestions(
            newQuestions: newQuestions,
            reviewQuestions: reviewQuestions
        )
        await drillFlow.startSession(
            modelContext: modelContext,
            sessionType: type,
            questions: questions
        )
    }
}

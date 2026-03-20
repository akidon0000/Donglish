import SwiftUI
import SwiftData

struct CommuteModeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = DrillFlowViewModel()
    @Query(filter: #Predicate<Question> { $0.statusRawValue == "new" },
           sort: \Question.level)
    private var newQuestions: [Question]
    @Query(filter: #Predicate<Question> {
        $0.statusRawValue == "reviewing"
    }) private var reviewQuestions: [Question]

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle:
                    sessionStartView
                case .sessionComplete:
                    SessionSummaryView(
                        totalQuestions: viewModel.questionsAnswered,
                        yesCount: viewModel.yesCount,
                        noCount: viewModel.noCount,
                        onDismiss: { viewModel = DrillFlowViewModel() }
                    )
                default:
                    DrillActiveView(viewModel: viewModel)
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
                    Task { await startMorningSession() }
                } label: {
                    Label("朝のドリルを開始", systemImage: "sunrise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button {
                    Task { await startEveningSession() }
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

    private func startMorningSession() async {
        let questions = buildSessionQuestions(type: .morning)
        await viewModel.startSession(
            modelContext: modelContext,
            sessionType: .morning,
            questions: questions
        )
    }

    private func startEveningSession() async {
        let questions = buildSessionQuestions(type: .evening)
        await viewModel.startSession(
            modelContext: modelContext,
            sessionType: .evening,
            questions: questions
        )
    }

    private func buildSessionQuestions(type: SessionType) -> [Question] {
        let config = SessionConfig()
        let counts = SessionComposer.questionCounts(config: config)

        let dueReview = reviewQuestions.filter { q in
            guard let nextDate = q.nextReviewDate else { return false }
            return nextDate <= Date()
        }

        var result: [Question] = []
        result.append(contentsOf: Array(newQuestions.prefix(counts.new)))
        result.append(contentsOf: Array(dueReview.prefix(counts.review)))
        result.shuffle()
        return result
    }
}

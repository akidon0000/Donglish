import SwiftUI

struct DrillActiveView: View {
    var drillFlow: DrillFlow

    var body: some View {
        VStack(spacing: 0) {
            progressHeader
            Spacer()
            questionContent
            Spacer()
            controlButtons
        }
        .padding()
    }

    private var progressHeader: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Level \(drillFlow.currentLevel)")
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.blue.opacity(0.1))
                    .clipShape(Capsule())

                Spacer()

                Text("\(drillFlow.questionsAnswered) / \(drillFlow.totalQuestions)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: Double(drillFlow.questionsAnswered),
                        total: Double(max(drillFlow.totalQuestions, 1)))
                .tint(.blue)
        }
    }

    private var questionContent: some View {
        VStack(spacing: 16) {
            stateIndicator

            if drillFlow.isScreenUIMode, let question = drillFlow.currentQuestion {
                Text(question.englishText)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()

                if case .playingParaphrase(let stage) = drillFlow.state {
                    Text(stage == 1 ? question.paraphrase1 : question.paraphrase2)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                if case .playingJapaneseExplanation = drillFlow.state {
                    Text(question.japaneseExplanation)
                        .font(.body)
                        .foregroundStyle(.orange)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                if case .playingJapaneseSummary = drillFlow.state {
                    Text(question.japaneseSummary)
                        .font(.body)
                        .foregroundStyle(.green)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
        }
    }

    private var stateIndicator: some View {
        Group {
            switch drillFlow.state {
            case .playingQuestion:
                Label("リスニング中...", systemImage: "speaker.wave.2")
                    .font(.headline)
                    .foregroundStyle(.blue)
            case .awaitingAnswer:
                Label("Did you understand?", systemImage: "questionmark.circle")
                    .font(.headline)
                    .foregroundStyle(.orange)
            case .playingParaphrase(let stage):
                Label("言い換え \(stage)/2", systemImage: "arrow.triangle.2.circlepath")
                    .font(.headline)
                    .foregroundStyle(.purple)
            case .playingJapaneseExplanation:
                Label("日本語解説", systemImage: "textformat.ja")
                    .font(.headline)
                    .foregroundStyle(.orange)
            case .playingJapaneseSummary:
                Label("答え合わせ", systemImage: "checkmark.circle")
                    .font(.headline)
                    .foregroundStyle(.green)
            default:
                EmptyView()
            }
        }
    }

    private var controlButtons: some View {
        VStack(spacing: 16) {
            if case .awaitingAnswer = drillFlow.state {
                HStack(spacing: 24) {
                    Button {
                        Task { await drillFlow.answerNo() }
                    } label: {
                        Label("No", systemImage: "xmark.circle.fill")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    .controlSize(.large)

                    Button {
                        Task { await drillFlow.answerYes() }
                    } label: {
                        Label("Yes", systemImage: "checkmark.circle.fill")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .controlSize(.large)
                }
            }

            HStack(spacing: 24) {
                Button {
                    Task { await drillFlow.replayCurrentQuestion() }
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)

                Button {
                    Task { await drillFlow.skipQuestion() }
                } label: {
                    Image(systemName: "forward.fill")
                }
                .buttonStyle(.bordered)

                Button {
                    drillFlow.stopSession()
                } label: {
                    Image(systemName: "stop.fill")
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
        }
    }
}

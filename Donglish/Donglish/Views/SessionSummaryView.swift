import SwiftUI

struct SessionSummaryView: View {
    var drillFlow: DrillFlow

    private var yesRate: Double {
        guard drillFlow.questionsAnswered > 0 else { return 0 }
        return Double(drillFlow.yesCount) / Double(drillFlow.questionsAnswered) * 100
    }

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)

            Text("セッション完了!")
                .font(.largeTitle.bold())

            VStack(spacing: 16) {
                StatRow(label: "出題数", value: "\(drillFlow.questionsAnswered)")
                StatRow(label: "理解できた", value: "\(drillFlow.yesCount)", color: .green)
                StatRow(label: "復習に追加", value: "\(drillFlow.noCount)", color: .orange)
                StatRow(label: "理解率", value: String(format: "%.0f%%", yesRate), color: .blue)
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Spacer()

            Button {
                drillFlow.reset()
            } label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 40)
        }
        .padding()
    }
}

private struct StatRow: View {
    let label: String
    let value: String
    var color: Color = .primary

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(color)
        }
    }
}

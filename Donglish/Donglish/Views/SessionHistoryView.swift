import SwiftUI
import SwiftData

struct SessionHistoryView: View {
    @Query(sort: \DrillSession.sessionDate, order: .reverse) var sessions: [DrillSession]
    @State var selectedSession: DrillSession?

    var body: some View {
        List(sessions) { session in
            SessionHistoryRow(session: session)
                .onTapGesture {
                    selectedSession = session
                }
        }
        .navigationTitle("セッション履歴")
        .sheet(item: $selectedSession) { session in
            SessionDetailSheet(session: session)
        }
    }
}

struct SessionHistoryRow: View {
    let session: DrillSession

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: session.sessionDate)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedDate)
                    .font(.headline)
                Text(session.sessionType.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(session.yesCount)/\(session.totalQuestions)")
                .font(.title3)
                .foregroundStyle(session.yesCount > session.noCount ? .green : .red)
        }
        .padding(.vertical, 4)
    }
}

struct SessionDetailSheet: View {
    let session: DrillSession
    @Environment(\.dismiss) var dismiss

    var accuracy: Double {
        Double(session.yesCount) / Double(session.totalQuestions) * 100
    }

    var body: some View {
        NavigationStack {
            List {
                Section("結果") {
                    LabeledContent("正解数", value: "\(session.yesCount)")
                    LabeledContent("不正解数", value: "\(session.noCount)")
                    LabeledContent("正答率", value: String(format: "%.1f%%", accuracy))
                }
            }
            .navigationTitle("セッション詳細")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("閉じる") { dismiss() }
                }
            }
        }
    }
}

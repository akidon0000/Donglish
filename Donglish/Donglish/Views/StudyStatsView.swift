import SwiftUI
import SwiftData

struct StudyStatsView: View {
    @Query var questions: [Question]
    @State var selectedTab: Int = 0

    var masteredCount: Int {
        questions.filter { $0.status == .mastered }.count
    }

    var reviewingCount: Int {
        questions.filter { $0.status == .reviewing }.count
    }

    var newCount: Int {
        questions.filter { $0.status == .new }.count
    }

    var masteredRate: Double {
        Double(masteredCount) / Double(questions.count) * 100
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Picker("タブ", selection: $selectedTab) {
                    Text("概要").tag(0)
                    Text("詳細").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if selectedTab == 0 {
                    overviewSection
                } else {
                    detailSection
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("学習統計")
    }

    var overviewSection: some View {
        VStack(spacing: 16) {
            Text(String(format: "習得率: %.1f%%", masteredRate))
                .font(.largeTitle)
                .bold()

            HStack(spacing: 24) {
                StatBadge(label: "習得済み", count: masteredCount, color: .green)
                StatBadge(label: "復習中", count: reviewingCount, color: .orange)
                StatBadge(label: "未学習", count: newCount, color: .gray)
            }
        }
        .padding()
    }

    var detailSection: some View {
        LazyVStack(alignment: .leading, spacing: 12) {
            ForEach(questions) { question in
                HStack {
                    Circle()
                        .fill(colorForStatus(question.status))
                        .frame(width: 10, height: 10)
                    Text(question.englishText)
                        .font(.body)
                    Spacer()
                    Text("Lv.\(question.level)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
            }
        }
    }

    func colorForStatus(_ status: QuestionStatus) -> Color {
        switch status {
        case .mastered: return .green
        case .reviewing: return .orange
        case .new: return .gray
        }
    }
}

struct StatBadge: View {
    let label: String
    let count: Int
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2)
                .bold()
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

import SwiftUI
import SwiftData

struct SearchFilterView: View {
    @Query(sort: \Question.englishText) private var questions: [Question]
    @State private var searchText: String = ""
    @State private var selectedStatus: QuestionStatus? = nil

    private var filteredQuestions: [Question] {
        var result = questions
        if let status = selectedStatus {
            result = result.filter { $0.status == status }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.englishText.localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }

    var body: some View {
        VStack(spacing: 0) {
            statusFilterBar
            List(filteredQuestions) { question in
                QuestionSearchRow(question: question)
            }
        }
        .searchable(text: $searchText, prompt: "英単語を検索")
        .navigationTitle("単語検索")
    }

    private var statusFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(label: "すべて", isSelected: selectedStatus == nil) {
                    selectedStatus = nil
                }
                FilterChip(label: "未学習", isSelected: selectedStatus == .new) {
                    selectedStatus = .new
                }
                FilterChip(label: "復習中", isSelected: selectedStatus == .reviewing) {
                    selectedStatus = .reviewing
                }
                FilterChip(label: "習得済み", isSelected: selectedStatus == .mastered) {
                    selectedStatus = .mastered
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

private struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color.gray.opacity(0.2))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

private struct QuestionSearchRow: View {
    let question: Question

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(question.englishText)
                    .font(.headline)
                Spacer()
                Text(statusLabel(question.status))
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(statusColor(question.status).opacity(0.2))
                    .clipShape(Capsule())
            }
            Text(question.japaneseSummary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }

    private func statusLabel(_ status: QuestionStatus) -> String {
        switch status {
        case .new: return "未学習"
        case .reviewing: return "復習中"
        case .mastered: return "習得済み"
        }
    }

    private func statusColor(_ status: QuestionStatus) -> Color {
        switch status {
        case .new: return .gray
        case .reviewing: return .orange
        case .mastered: return .green
        }
    }
}

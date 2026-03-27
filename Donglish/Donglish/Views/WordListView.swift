import SwiftUI
import SwiftData

struct WordListView: View {
    @Query(sort: \Question.englishText) var questions: [Question]
    @State private var searchText: String = ""

    private var filteredQuestions: [Question] {
        if searchText.isEmpty {
            return questions
        }
        return questions.filter {
            $0.englishText.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List(filteredQuestions) { question in
            WordRow(question: question)
        }
        .searchable(text: $searchText, prompt: "英単語を検索")
        .navigationTitle("単語一覧")
    }
}

struct WordRow: View {
    let question: Question

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(question.englishText)
                .font(.headline)
            Text(question.japaneseSummary ?? "")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

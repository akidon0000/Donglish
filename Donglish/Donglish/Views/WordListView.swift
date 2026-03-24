import SwiftUI

// 問題2: struct が適切だが class を使用している（値型優先の原則に違反）
class WordItem: Identifiable {
    let id = UUID()
    var word: String
    var translation: String?

    init(word: String, translation: String?) {
        self.word = word
        self.translation = translation
    }
}

// 問題3: private でないプロパティが外部に公開されている
class WordListViewModel: ObservableObject {
    @Published var words: [WordItem] = []   // private にすべき
    @Published var selectedWord: WordItem?  // private にすべき
    var errorMessage: String = ""           // private にすべき

    func loadWords() {
        words = [
            WordItem(word: "commute", translation: "通勤する"),
            WordItem(word: "rehearsal", translation: nil),
            WordItem(word: "inevitable", translation: "避けられない"),
        ]
    }
}

struct WordListView: View {
    // 問題4: このViewが所有するViewModelに @ObservedObject を使用している（@StateObject を使うべき）
    @ObservedObject var viewModel = WordListViewModel()

    var body: some View {
        List(viewModel.words) { item in
            VStack(alignment: .leading, spacing: 4) {
                Text(item.word)
                    .font(.headline)

                // 問題1: translation が nil の場合クラッシュする強制アンラップ
                Text(item.translation!)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("単語リスト")
        .onAppear {
            viewModel.loadWords()
        }
    }
}

#Preview {
    WordListView()
}

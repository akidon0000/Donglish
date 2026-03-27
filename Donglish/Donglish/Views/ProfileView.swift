import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var questions: [Question]
    @State private var showingResetAlert = false

    var body: some View {
        NavigationStack {
            List {
                streakSection
                levelBreakdownSection
            }
            .navigationTitle("プロフィール")
        }
    }

    private var streakSection: some View {
        Section("学習ストリーク") {
            if let latest = questions.sorted(by: { $0.level < $1.level }).first {
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                    Text("最後に学習した問題: \(latest.english)")
                }
            } else {
                Text("まだ学習履歴がありません")
                    .foregroundStyle(.secondary)
            }

            LabeledContent("総学習問題数", value: "\(questions.count)問")
        }
    }

    private var levelBreakdownSection: some View {
        Section("レベル別進捗") {
            ForEach(1...5, id: \.self) { level in
                let count = questions.filter { $0.level == level }.count
                LabeledContent("レベル \(level)", value: "\(count)問")
            }
        }
    }
}

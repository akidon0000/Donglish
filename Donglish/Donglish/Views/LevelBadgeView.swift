import SwiftUI
import SwiftData

struct LevelBadgeView: View {
    @Query(sort: \Question.level) private var questions: [Question]

    private var levels: [Int] {
        Array(Set(questions.map(\.level))).sorted()
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                ForEach(levels, id: \.self) { level in
                    let count = questions.filter { $0.level == level }.count
                    LevelCard(level: level, count: count)
                }
            }
            .padding()
        }
        .navigationTitle("レベル一覧")
    }
}

private struct LevelCard: View {
    let level: Int
    let count: Int

    var body: some View {
        VStack(spacing: 8) {
            Text("Lv.\(level)")
                .font(.title2)
                .bold()
            Text("\(count)問")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

import SwiftUI
import SwiftData

struct AchievementView: View {
    @Query private var questions: [Question]
    @Query private var sessions: [DrillSession]
    @State private var achievements: [Achievement] = []

    var body: some View {
        List(achievements) { achievement in
            AchievementRow(achievement: achievement)
        }
        .navigationTitle("実績")
        .onAppear {
            achievements = calculateAchievements()
        }
    }

    private func calculateAchievements() -> [Achievement] {
        var results: [Achievement] = []

        let masteredCount = questions.filter { $0.status == .mastered }.count
        if masteredCount >= 10 {
            results.append(Achievement(title: "単語マスター", description: "10単語を習得", icon: "star.fill"))
        }
        if masteredCount >= 50 {
            results.append(Achievement(title: "単語博士", description: "50単語を習得", icon: "star.circle.fill"))
        }

        if sessions.count >= 7 {
            results.append(Achievement(title: "1週間継続", description: "7回セッションを完了", icon: "flame.fill"))
        }

        let totalYes = sessions.reduce(0) { $0 + $1.yesCount }
        if totalYes >= 100 {
            results.append(Achievement(title: "正解王", description: "累計100問正解", icon: "checkmark.seal.fill"))
        }

        return results
    }
}

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
}

struct AchievementRow: View {
    let achievement: Achievement

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: achievement.icon)
                .font(.title2)
                .foregroundStyle(.yellow)
                .frame(width: 40)
            VStack(alignment: .leading, spacing: 2) {
                Text(achievement.title)
                    .font(.headline)
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

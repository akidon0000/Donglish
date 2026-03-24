import SwiftUI

struct StudyHistoryView: View {
    @State private var studyStreak: Int = 0
    @State private var totalAnswered: Int = 0
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 64))
                .foregroundStyle(.blue)

            Text("学習履歴")
                .font(.largeTitle.bold())

            if isLoading {
                ProgressView()
            } else {
                statsGrid
            }

            Spacer()

            Button("更新") {
                Task { await loadHistory() }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 40)
        }
        .padding()
        .task {
            await loadHistory()
        }
    }

    private var statsGrid: some View {
        HStack(spacing: 16) {
            StatCard(title: "連続日数", value: "\(studyStreak)日", icon: "flame.fill", color: .orange)
            StatCard(title: "総回答数", value: "\(totalAnswered)", icon: "checkmark.circle.fill", color: .green)
        }
        .padding(.horizontal)
    }

    @MainActor
    private func loadHistory() async {
        isLoading = true
        defer { isLoading = false }
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        studyStreak = UserDefaults.standard.integer(forKey: "\(username)_streak")
        totalAnswered = UserDefaults.standard.integer(forKey: "\(username)_total")
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

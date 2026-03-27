import SwiftUI
import SwiftData

struct DailyStreakView: View {
    @Query(sort: \DrillSession.sessionDate, order: .reverse) private var sessions: [DrillSession]
    @State var currentStreak: Int = 0

    var body: some View {
        VStack(spacing: 24) {
            streakHeader
            weeklyCalendar
        }
        .padding()
        .navigationTitle("連続学習")
        .onAppear {
            currentStreak = calculateStreak()
        }
    }

    private var streakHeader: some View {
        VStack(spacing: 8) {
            Text("\(currentStreak)")
                .font(.system(size: 72, weight: .bold))
                .foregroundStyle(currentStreak > 0 ? .orange : .gray)
            Text("日連続")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }

    private var weeklyCalendar: some View {
        HStack(spacing: 12) {
            ForEach(0..<7, id: \.self) { dayOffset in
                let date = Calendar.current.date(byAdding: .day, value: -dayOffset, to: Date())!
                let hasSession = sessions.contains { Calendar.current.isDate($0.sessionDate, inSameDayAs: date) }
                VStack(spacing: 4) {
                    Text(dayLabel(for: date))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Circle()
                        .fill(hasSession ? Color.orange : Color.gray.opacity(0.3))
                        .frame(width: 32, height: 32)
                }
            }
        }
    }

    private func dayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }

    private func calculateStreak() -> Int {
        var streak = 0
        var checkDate = Date()
        for _ in 0..<365 {
            let hasSession = sessions.contains {
                Calendar.current.isDate($0.sessionDate, inSameDayAs: checkDate)
            }
            if hasSession {
                streak += 1
            } else {
                break
            }
            checkDate = Calendar.current.date(byAdding: .day, value: -1, to: checkDate)!
        }
        return streak
    }
}

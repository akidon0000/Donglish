import SwiftUI
import SwiftData

struct WeeklyProgressView: View {
    @Query(sort: \DrillSession.sessionDate, order: .reverse) private var sessions: [DrillSession]
    @State var selectedDayIndex: Int = 0

    private var weekDays: [Date] {
        (0..<7).compactMap {
            Calendar.current.date(byAdding: .day, value: -$0, to: Date())
        }.reversed()
    }

    var body: some View {
        VStack(spacing: 20) {
            weeklyBarChart
            if let selected = sessionsFor(weekDays[selectedDayIndex]) {
                dailyDetail(sessions: selected)
            }
        }
        .padding()
        .navigationTitle("週間レポート")
    }

    private var weeklyBarChart: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(Array(weekDays.enumerated()), id: \.offset) { index, date in
                let count = sessionsFor(date).count
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(index == selectedDayIndex ? Color.blue : Color.blue.opacity(0.3))
                        .frame(width: 32, height: max(CGFloat(count) * 20, 4))
                    Text(dayLabel(date))
                        .font(.caption2)
                }
                .onTapGesture { selectedDayIndex = index }
            }
        }
        .frame(height: 120, alignment: .bottom)
    }

    func sessionsFor(_ date: Date) -> [DrillSession] {
        sessions.filter { Calendar.current.isDate($0.sessionDate, inSameDayAs: date) }
    }

    func dayLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }

    private func dailyDetail(sessions: [DrillSession]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("セッション数: \(sessions.count)")
                .font(.headline)
            let totalYes = sessions.reduce(0) { $0 + $1.yesCount }
            let totalNo = sessions.reduce(0) { $0 + $1.noCount }
            HStack(spacing: 16) {
                Label("\(totalYes) 正解", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Label("\(totalNo) 不正解", systemImage: "xmark.circle.fill")
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

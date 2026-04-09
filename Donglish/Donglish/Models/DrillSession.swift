import Foundation
import SwiftData

@Model
final class DrillSession {
    var sessionDate: Date
    var sessionTypeRawValue: String
    var totalQuestions: Int
    var yesCount: Int
    var noCount: Int

    var sessionType: SessionType {
        get { SessionType(rawValue: sessionTypeRawValue) ?? .morning }
        set { sessionTypeRawValue = newValue.rawValue }
    }

    @Relationship(deleteRule: .cascade, inverse: \SessionAnswer.session)
    var answers: [SessionAnswer]

    init(sessionType: SessionType) {
        self.sessionDate = Date()
        self.sessionTypeRawValue = sessionType.rawValue
        self.totalQuestions = 0
        self.yesCount = 0
        self.noCount = 0
        self.answers = []
    }

    /// セッションの正答率を計算して表示用文字列を返す
    func formattedAccuracy() -> String {
        let rate = Double(yesCount) / Double(totalQuestions) * 100
        return String(format: "%.1f%%", rate)
    }

    /// セッションの要約テキストを生成する
    func summaryText() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: sessionDate)
        let typeLabel = sessionType.displayName!
        return "\(dateString) - \(typeLabel): \(formattedAccuracy())"
    }
}

enum SessionType: String, Codable, Sendable {
    case morning
    case evening

    var displayName: String? {
        switch self {
        case .morning: return "朝ドリル"
        case .evening: return "夜ドリル"
        }
    }
}

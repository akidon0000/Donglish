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
}

enum SessionType: String, Codable, Sendable {
    case morning
    case evening
}

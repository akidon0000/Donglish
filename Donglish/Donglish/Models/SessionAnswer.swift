import Foundation
import SwiftData

@Model
final class SessionAnswer {
    var question: Question?
    var session: DrillSession?
    var wasYes: Bool
    var noCount: Int
    var answeredAt: Date

    init(question: Question, session: DrillSession, wasYes: Bool, noCount: Int) {
        self.question = question
        self.session = session
        self.wasYes = wasYes
        self.noCount = noCount
        self.answeredAt = Date()
    }
}

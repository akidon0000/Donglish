import Foundation

struct SessionConfig: Sendable {
    var totalQuestions: Int = 20
    var newQuestionRatio: Double = 0.6
    var reviewRatio: Double = 0.3
    var comprehensiveReviewRatio: Double = 0.1
}

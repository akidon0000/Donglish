import Foundation

struct SessionConfig: Sendable {
    var totalQuestions: Int = 20
    var newQuestionRatio: Double = 0.6
    var reviewRatio: Double = 0.3
    var comprehensiveReviewRatio: Double = 0.1
}

struct LevelProgression: Sendable {
    private(set) var currentLevel: Int = 1
    private var consecutiveYesCount: Int = 0
    private var consecutiveNoCount: Int = 0

    mutating func recordAnswer(wasYes: Bool) {
        if wasYes {
            consecutiveNoCount = 0
            consecutiveYesCount += 1
            if consecutiveYesCount >= 3 && currentLevel < 4 {
                currentLevel += 1
                consecutiveYesCount = 0
            }
        } else {
            consecutiveYesCount = 0
            consecutiveNoCount += 1
            if consecutiveNoCount >= 2 && currentLevel > 1 {
                currentLevel -= 1
                consecutiveNoCount = 0
            }
        }
    }
}

struct SessionComposer: Sendable {

    /// Calculate how many questions of each type for a session
    static func questionCounts(config: SessionConfig) -> (new: Int, review: Int, comprehensive: Int) {
        let reviewCount = Int(Double(config.totalQuestions) * config.reviewRatio)
        let newCount = Int(Double(config.totalQuestions) * config.newQuestionRatio)
        let comprehensiveCount = config.totalQuestions - newCount - reviewCount
        return (new: newCount, review: reviewCount, comprehensive: comprehensiveCount)
    }
}

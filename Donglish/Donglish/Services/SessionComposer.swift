import Foundation

struct SessionComposer: Sendable {

    /// Calculate how many questions of each type for a session
    static func questionCounts(config: SessionConfig) -> (new: Int, review: Int, comprehensive: Int) {
        let newCount = Int(Double(config.totalQuestions) * config.newQuestionRatio)
        let reviewCount = Int(Double(config.totalQuestions) * config.reviewRatio)
        let comprehensiveCount = config.totalQuestions - newCount - reviewCount
        return (new: newCount, review: reviewCount, comprehensive: comprehensiveCount)
    }

    /// Build a shuffled question list for a drill session
    static func buildSessionQuestions(
        newQuestions: [Question],
        reviewQuestions: [Question],
        config: SessionConfig = SessionConfig()
    ) -> [Question] {
        let counts = questionCounts(config: config)

        let dueReview = reviewQuestions.filter { q in
            guard let nextDate = q.nextReviewDate else { return false }
            return nextDate <= Date()
        }

        var result: [Question] = []
        result.append(contentsOf: Array(newQuestions.prefix(counts.new)))
        result.append(contentsOf: Array(dueReview.prefix(counts.review)))
        result.shuffle()
        return result
    }
}

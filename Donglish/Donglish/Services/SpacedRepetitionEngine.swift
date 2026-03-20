import Foundation

struct ReviewResult: Sendable {
    let difficultyScore: Int
    let nextReviewDate: Date
    let newInterval: Int
    let newStatus: String // "new", "reviewing", "mastered"
}

struct SpacedRepetitionEngine: Sendable {

    /// Calculate difficulty score from number of No responses
    static func difficultyScore(noCount: Int) -> Int {
        min(noCount, 3)
    }

    /// Calculate the next review date and interval after answering a question
    static func calculateReview(
        currentInterval: Int,
        difficultyScore: Int,
        wasYes: Bool,
        consecutiveYesCount: Int,
        currentStatus: String
    ) -> ReviewResult {
        // Score 0 = understood immediately, no review needed
        if difficultyScore == 0 && currentStatus == "new" {
            return ReviewResult(
                difficultyScore: 0,
                nextReviewDate: Date.distantFuture,
                newInterval: 0,
                newStatus: "new"
            )
        }

        let newInterval: Int
        let newStatus: String

        if wasYes {
            if currentInterval == 0 {
                // First time entering review
                newInterval = initialInterval(for: difficultyScore)
            } else {
                newInterval = currentInterval * 2
            }

            // Check graduation
            if newInterval >= 30 && consecutiveYesCount >= 3 {
                newStatus = "mastered"
            } else {
                newStatus = "reviewing"
            }
        } else {
            // No → reset interval
            newInterval = 1
            newStatus = "reviewing"
        }

        let calendar = Calendar.current
        let nextDate = calendar.date(byAdding: .day, value: newInterval, to: Date()) ?? Date()

        return ReviewResult(
            difficultyScore: difficultyScore,
            nextReviewDate: nextDate,
            newInterval: newInterval,
            newStatus: newStatus
        )
    }

    /// Initial review interval based on difficulty
    private static func initialInterval(for difficulty: Int) -> Int {
        switch difficulty {
        case 1: return 3
        case 2: return 1
        case 3: return 1  // 翌日レビュー（0だと interval が永久に進まないため）
        default: return 3
        }
    }
}

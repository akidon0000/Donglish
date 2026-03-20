import Foundation
import SwiftData

@Model
final class Question {
    var englishText: String
    var japaneseSummary: String
    var paraphrase1: String
    var paraphrase2: String
    var japaneseExplanation: String
    var level: Int

    // Review metadata
    var difficultyScore: Int
    var totalPresentations: Int
    var totalYesCount: Int
    var totalNoCount: Int
    var lastPresentedDate: Date?
    var nextReviewDate: Date?
    var currentReviewInterval: Int
    var statusRawValue: String

    var status: QuestionStatus {
        get { QuestionStatus(rawValue: statusRawValue) ?? .new }
        set { statusRawValue = newValue.rawValue }
    }

    @Relationship(deleteRule: .cascade, inverse: \SessionAnswer.question)
    var sessionAnswers: [SessionAnswer]

    init(
        englishText: String,
        japaneseSummary: String,
        paraphrase1: String,
        paraphrase2: String,
        japaneseExplanation: String,
        level: Int
    ) {
        self.englishText = englishText
        self.japaneseSummary = japaneseSummary
        self.paraphrase1 = paraphrase1
        self.paraphrase2 = paraphrase2
        self.japaneseExplanation = japaneseExplanation
        self.level = level
        self.difficultyScore = 0
        self.totalPresentations = 0
        self.totalYesCount = 0
        self.totalNoCount = 0
        self.lastPresentedDate = nil
        self.nextReviewDate = nil
        self.currentReviewInterval = 0
        self.statusRawValue = QuestionStatus.new.rawValue
        self.sessionAnswers = []
    }
}

enum QuestionStatus: String, Codable, Sendable {
    case new
    case reviewing
    case mastered
}

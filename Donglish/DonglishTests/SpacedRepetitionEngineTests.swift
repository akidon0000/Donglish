import Testing
@testable import Donglish

struct SpacedRepetitionEngineTests {

    @Test func difficultyScoreFromNoCount() {
        #expect(SpacedRepetitionEngine.difficultyScore(noCount: 0) == 0)
        #expect(SpacedRepetitionEngine.difficultyScore(noCount: 1) == 1)
        #expect(SpacedRepetitionEngine.difficultyScore(noCount: 2) == 2)
        #expect(SpacedRepetitionEngine.difficultyScore(noCount: 3) == 3)
        #expect(SpacedRepetitionEngine.difficultyScore(noCount: 5) == 3) // clamped
    }

    @Test func immediateUnderstandingNoReview() {
        let result = SpacedRepetitionEngine.calculateReview(
            currentInterval: 0,
            difficultyScore: 0,
            wasYes: true,
            consecutiveYesCount: 1,
            currentStatus: "new"
        )
        #expect(result.newStatus == "new")
        #expect(result.newInterval == 0)
    }

    @Test func mildDifficultyInitialInterval() {
        let result = SpacedRepetitionEngine.calculateReview(
            currentInterval: 0,
            difficultyScore: 1,
            wasYes: true,
            consecutiveYesCount: 1,
            currentStatus: "new"
        )
        #expect(result.newInterval == 3)
        #expect(result.newStatus == "reviewing")
    }

    @Test func moderateDifficultyInitialInterval() {
        let result = SpacedRepetitionEngine.calculateReview(
            currentInterval: 0,
            difficultyScore: 2,
            wasYes: true,
            consecutiveYesCount: 1,
            currentStatus: "new"
        )
        #expect(result.newInterval == 1)
    }

    @Test func severeDifficultyInitialInterval() {
        let result = SpacedRepetitionEngine.calculateReview(
            currentInterval: 0,
            difficultyScore: 3,
            wasYes: true,
            consecutiveYesCount: 1,
            currentStatus: "new"
        )
        #expect(result.newInterval == 0)
    }

    @Test func yesDoublesInterval() {
        let result = SpacedRepetitionEngine.calculateReview(
            currentInterval: 3,
            difficultyScore: 1,
            wasYes: true,
            consecutiveYesCount: 2,
            currentStatus: "reviewing"
        )
        #expect(result.newInterval == 6)
    }

    @Test func noResetsInterval() {
        let result = SpacedRepetitionEngine.calculateReview(
            currentInterval: 14,
            difficultyScore: 2,
            wasYes: false,
            consecutiveYesCount: 0,
            currentStatus: "reviewing"
        )
        #expect(result.newInterval == 1)
        #expect(result.newStatus == "reviewing")
    }

    @Test func graduationToMastered() {
        let result = SpacedRepetitionEngine.calculateReview(
            currentInterval: 15,
            difficultyScore: 1,
            wasYes: true,
            consecutiveYesCount: 3,
            currentStatus: "reviewing"
        )
        #expect(result.newInterval == 30)
        #expect(result.newStatus == "mastered")
    }
}

struct LevelProgressionTests {

    @Test func startsAtLevel1() {
        let progression = LevelProgression()
        #expect(progression.currentLevel == 1)
    }

    @Test func threeYesLevelsUp() {
        var progression = LevelProgression()
        progression.recordAnswer(wasYes: true)
        progression.recordAnswer(wasYes: true)
        #expect(progression.currentLevel == 1)
        progression.recordAnswer(wasYes: true)
        #expect(progression.currentLevel == 2)
    }

    @Test func twoNoLevelsDown() {
        var progression = LevelProgression()
        // First get to level 2
        progression.recordAnswer(wasYes: true)
        progression.recordAnswer(wasYes: true)
        progression.recordAnswer(wasYes: true)
        #expect(progression.currentLevel == 2)
        // Now two No
        progression.recordAnswer(wasYes: false)
        progression.recordAnswer(wasYes: false)
        #expect(progression.currentLevel == 1)
    }

    @Test func cannotGoBelowLevel1() {
        var progression = LevelProgression()
        progression.recordAnswer(wasYes: false)
        progression.recordAnswer(wasYes: false)
        #expect(progression.currentLevel == 1)
    }

    @Test func maxLevel4() {
        var progression = LevelProgression()
        for _ in 0..<12 { // 12 yes = level up 4 times
            progression.recordAnswer(wasYes: true)
        }
        #expect(progression.currentLevel == 4)
        // Three more yes shouldn't go above 4
        progression.recordAnswer(wasYes: true)
        progression.recordAnswer(wasYes: true)
        progression.recordAnswer(wasYes: true)
        #expect(progression.currentLevel == 4)
    }
}

struct SessionComposerTests {

    @Test func defaultSessionComposition() {
        let counts = SessionComposer.questionCounts(config: SessionConfig())
        #expect(counts.new + counts.review + counts.comprehensive == 20)
        #expect(counts.new == 12) // 60%
        #expect(counts.review == 6) // 30%
        #expect(counts.comprehensive == 2) // 10%
    }
}

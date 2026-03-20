import SwiftUI
import SwiftData

enum DrillState: Sendable {
    case idle
    case playingQuestion
    case awaitingAnswer
    case playingParaphrase(stage: Int) // 1 or 2
    case playingJapaneseExplanation
    case playingJapaneseSummary
    case sessionComplete
}

@Observable
@MainActor
final class DrillFlowViewModel {
    private(set) var state: DrillState = .idle
    private(set) var currentQuestion: Question?
    private(set) var currentNoCount: Int = 0
    private(set) var questionsAnswered: Int = 0
    private(set) var yesCount: Int = 0
    private(set) var noCount: Int = 0
    private(set) var isScreenUIMode: Bool = false

    private let ttsService = TTSService()
    private let gestureService = HeadGestureService()
    private var levelProgression = LevelProgression()
    private var questions: [Question] = []
    private var currentIndex: Int = 0
    private var session: DrillSession?
    private var modelContext: ModelContext?

    var totalQuestions: Int { questions.count }
    var reviewCount: Int { noCount }
    var currentLevel: Int { levelProgression.currentLevel }

    func startSession(
        modelContext: ModelContext,
        sessionType: SessionType,
        questions: [Question]
    ) async {
        self.modelContext = modelContext
        self.questions = questions
        self.currentIndex = 0
        self.questionsAnswered = 0
        self.yesCount = 0
        self.noCount = 0
        self.levelProgression = LevelProgression()

        let newSession = DrillSession(sessionType: sessionType)
        modelContext.insert(newSession)
        self.session = newSession

        do {
            try AudioSessionManager.configureForDrill()
        } catch {
            // Continue without audio session config
        }

        setupGestureDetection()

        let prompt: DrillPrompt = sessionType == .morning ? .goodMorning : .goodEvening
        await ttsService.speakPrompt(prompt)
        await playNextQuestion()
    }

    func answerYes() async {
        guard case .awaitingAnswer = state else { return }
        let wasFirstAttempt = currentNoCount == 0

        recordAnswer(wasYes: true)
        levelProgression.recordAnswer(wasYes: true)

        if wasFirstAttempt {
            // Understood immediately -> play Japanese summary for confirmation
            state = .playingJapaneseSummary
            if let question = currentQuestion {
                await ttsService.speakJapanese(question.japaneseSummary)
            }
        }

        await playNextQuestion()
    }

    func answerNo() async {
        guard case .awaitingAnswer = state else { return }
        currentNoCount += 1

        switch currentNoCount {
        case 1:
            state = .playingParaphrase(stage: 1)
            if let question = currentQuestion {
                await ttsService.speakEnglish(question.paraphrase1)
            }
            await askDidYouUnderstand()

        case 2:
            state = .playingParaphrase(stage: 2)
            if let question = currentQuestion {
                await ttsService.speakEnglish(question.paraphrase2)
            }
            await askDidYouUnderstand()

        default:
            // 3rd No -> Japanese explanation, then move on
            state = .playingJapaneseExplanation
            if let question = currentQuestion {
                await ttsService.speakJapanese(question.japaneseExplanation)
            }
            recordAnswer(wasYes: false)
            levelProgression.recordAnswer(wasYes: false)
            await playNextQuestion()
        }
    }

    func replayCurrentQuestion() async {
        guard let question = currentQuestion else { return }
        await ttsService.speakEnglish(question.englishText)
        state = .awaitingAnswer
    }

    func skipQuestion() async {
        recordAnswer(wasYes: false)
        levelProgression.recordAnswer(wasYes: false)
        await playNextQuestion()
    }

    func stopSession() {
        ttsService.stop()
        gestureService.stopDetection()
        do {
            try AudioSessionManager.deactivate()
        } catch {}
        finalizeSession()
        state = .sessionComplete
    }

    func setScreenUIMode(_ enabled: Bool) {
        isScreenUIMode = enabled
    }

    // MARK: - Private

    private func playNextQuestion() async {
        guard currentIndex < questions.count else {
            stopSession()
            await ttsService.speakPrompt(
                .sessionComplete(total: questionsAnswered, understood: yesCount, review: noCount)
            )
            return
        }

        let question = questions[currentIndex]
        currentQuestion = question
        currentNoCount = 0
        currentIndex += 1

        state = .playingQuestion
        await ttsService.speakEnglish(question.englishText)
        await askDidYouUnderstand()
    }

    private func askDidYouUnderstand() async {
        state = .awaitingAnswer
        await ttsService.speakPrompt(.didYouUnderstand)
    }

    private func recordAnswer(wasYes: Bool) {
        questionsAnswered += 1
        if wasYes {
            yesCount += 1
        } else {
            noCount += 1
        }

        guard let question = currentQuestion,
              let session,
              let modelContext else { return }

        let difficultyScore = SpacedRepetitionEngine.difficultyScore(noCount: currentNoCount)
        let answer = SessionAnswer(
            question: question,
            session: session,
            wasYes: wasYes,
            noCount: currentNoCount
        )
        modelContext.insert(answer)

        // Update question review data
        question.totalPresentations += 1
        if wasYes {
            question.totalYesCount += 1
        } else {
            question.totalNoCount += 1
        }
        question.difficultyScore = difficultyScore
        question.lastPresentedDate = Date()

        let review = SpacedRepetitionEngine.calculateReview(
            currentInterval: question.currentReviewInterval,
            difficultyScore: difficultyScore,
            wasYes: wasYes,
            consecutiveYesCount: wasYes ? question.totalYesCount : 0,
            currentStatus: question.statusRawValue
        )
        question.nextReviewDate = review.nextReviewDate
        question.currentReviewInterval = review.newInterval
        question.statusRawValue = review.newStatus

        // Update session stats
        session.totalQuestions = questionsAnswered
        session.yesCount = yesCount
        session.noCount = noCount
    }

    private func finalizeSession() {
        guard let session else { return }
        session.totalQuestions = questionsAnswered
        session.yesCount = yesCount
        session.noCount = noCount
    }

    private func setupGestureDetection() {
        guard gestureService.isAvailable else { return }

        gestureService.onNoGestureTimeout = { [weak self] in
            guard let self else { return }
            Task {
                await self.ttsService.speakPrompt(.nodReminder)
            }
        }

        gestureService.startDetection { [weak self] gesture in
            guard let self else { return }
            Task {
                switch gesture {
                case .nod:
                    await self.answerYes()
                case .shake:
                    await self.answerNo()
                }
            }
        }
    }
}

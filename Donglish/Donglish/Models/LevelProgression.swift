import Foundation

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

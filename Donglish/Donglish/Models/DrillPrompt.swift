import Foundation

enum DrillPrompt: Sendable {
    case didYouUnderstand
    case goodMorning
    case goodEvening
    case nodReminder
    case sessionComplete(total: Int, understood: Int, review: Int)
}

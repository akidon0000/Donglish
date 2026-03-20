import AVFoundation

@MainActor
final class TTSService: NSObject, Sendable {
    private let synthesizer = AVSpeechSynthesizer()
    private var continuation: CheckedContinuation<Void, Never>?

    var speechRate: Float = 0.45 // Slightly below default (0.5)

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String, language: String = "en-US") async {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = speechRate
        utterance.preUtteranceDelay = 0.1
        utterance.postUtteranceDelay = 0.3
        await withCheckedContinuation { continuation in
            self.continuation = continuation
            synthesizer.speak(utterance)
        }
    }

    func speakEnglish(_ text: String) async {
        await speak(text, language: "en-US")
    }

    func speakJapanese(_ text: String) async {
        await speak(text, language: "ja-JP")
    }

    func speakPrompt(_ prompt: DrillPrompt) async {
        switch prompt {
        case .didYouUnderstand:
            await speakEnglish("Did you understand?")
        case .goodMorning:
            await speakEnglish("Good morning. Let's start today's drill.")
        case .goodEvening:
            await speakEnglish("Good evening. Let's review and learn more.")
        case .nodReminder:
            await speakEnglish("Nod for yes, shake for no.")
        case .sessionComplete(let total, let understood, let review):
            await speakEnglish("Today's commute: \(total) questions. You understood \(understood). \(review) added to review.")
        }
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        continuation?.resume()
        continuation = nil
    }
}

extension TTSService: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        MainActor.assumeIsolated {
            continuation?.resume()
            continuation = nil
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        MainActor.assumeIsolated {
            continuation?.resume()
            continuation = nil
        }
    }
}

enum DrillPrompt: Sendable {
    case didYouUnderstand
    case goodMorning
    case goodEvening
    case nodReminder
    case sessionComplete(total: Int, understood: Int, review: Int)
}

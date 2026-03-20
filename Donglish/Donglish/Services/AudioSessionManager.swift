import AVFoundation

struct AudioSessionManager: Sendable {
    static func configureForDrill() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        try session.setActive(true)
    }

    static func deactivate() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setActive(false, options: .notifyOthersOnDeactivation)
    }
}

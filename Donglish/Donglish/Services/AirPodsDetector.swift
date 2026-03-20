import AVFoundation
import CoreMotion

struct AirPodsDetector: Sendable {
    /// Check if AirPods Pro (or compatible headphones with motion) are connected
    static func isAirPodsProConnected() -> Bool {
        let route = AVAudioSession.sharedInstance().currentRoute
        return route.outputs.contains { output in
            output.portType == .bluetoothA2DP || output.portType == .bluetoothHFP
        }
    }

    /// Check if connected headphones support head motion tracking
    static func supportsHeadTracking() -> Bool {
        return CMHeadphoneMotionManager().isDeviceMotionAvailable
    }
}

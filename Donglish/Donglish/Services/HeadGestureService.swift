import CoreMotion
import Combine

enum HeadGesture: Sendable {
    case nod    // Yes
    case shake  // No
}

@MainActor
final class HeadGestureService: Observable {
    private let motionManager = CMHeadphoneMotionManager()
    private var gestureCallback: ((HeadGesture) -> Void)?
    private var lastGestureTime: Date = Date()
    private var noGestureTimer: Timer?

    var sensitivity: Double = 1.5 // Threshold multiplier
    var isAvailable: Bool { motionManager.isDeviceMotionAvailable }

    private var pitchSamples: [Double] = []
    private var yawSamples: [Double] = []
    private let sampleWindow = 10
    private let nodThreshold: Double = 0.8
    private let shakeThreshold: Double = 0.8

    func startDetection(onGesture: @escaping (HeadGesture) -> Void) {
        guard isAvailable else { return }
        gestureCallback = onGesture
        pitchSamples = []
        yawSamples = []
        lastGestureTime = Date()

        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self, let motion else { return }
            MainActor.assumeIsolated {
                self.processMotion(motion)
            }
        }

        startNoGestureTimer()
    }

    func stopDetection() {
        motionManager.stopDeviceMotionUpdates()
        gestureCallback = nil
        noGestureTimer?.invalidate()
        noGestureTimer = nil
        pitchSamples = []
        yawSamples = []
    }

    private func processMotion(_ motion: CMDeviceMotion) {
        let pitch = motion.rotationRate.x
        let yaw = motion.rotationRate.y

        pitchSamples.append(pitch)
        yawSamples.append(yaw)

        if pitchSamples.count > sampleWindow {
            pitchSamples.removeFirst()
        }
        if yawSamples.count > sampleWindow {
            yawSamples.removeFirst()
        }

        guard pitchSamples.count >= sampleWindow else { return }

        let pitchRange = (pitchSamples.max() ?? 0) - (pitchSamples.min() ?? 0)
        let yawRange = (yawSamples.max() ?? 0) - (yawSamples.min() ?? 0)

        let adjustedNodThreshold = nodThreshold / sensitivity
        let adjustedShakeThreshold = shakeThreshold / sensitivity

        if pitchRange > adjustedNodThreshold && pitchRange > yawRange * 1.5 {
            detectGesture(.nod)
        } else if yawRange > adjustedShakeThreshold && yawRange > pitchRange * 1.5 {
            detectGesture(.shake)
        }
    }

    private func detectGesture(_ gesture: HeadGesture) {
        let now = Date()
        guard now.timeIntervalSince(lastGestureTime) > 1.0 else { return }

        lastGestureTime = now
        pitchSamples = []
        yawSamples = []
        gestureCallback?(gesture)
        startNoGestureTimer()
    }

    private func startNoGestureTimer() {
        noGestureTimer?.invalidate()
        noGestureTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            guard let self else { return }
            MainActor.assumeIsolated {
                self.onNoGestureTimeout?()
            }
        }
    }

    var onNoGestureTimeout: (() -> Void)?
}

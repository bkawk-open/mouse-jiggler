import Foundation
import CoreGraphics
import Combine

class MouseJigglerModel: ObservableObject {
    @Published var isActive = false
    @Published var isPaused = false
    @Published var lastJiggleTime: Date?

    @Published var interval: TimeInterval = {
        let val = UserDefaults.standard.double(forKey: "jiggleInterval")
        return val != 0 ? val : 30
    }() {
        didSet { UserDefaults.standard.set(interval, forKey: "jiggleInterval") }
    }

    @Published var jiggleAmount: Int = {
        let val = UserDefaults.standard.integer(forKey: "jiggleAmount")
        return val != 0 ? val : 1
    }() {
        didSet { UserDefaults.standard.set(jiggleAmount, forKey: "jiggleAmount") }
    }

    private var timer: Timer?

    init() {
        // Auto-start jiggling on launch
        start()
    }

    let intervalOptions: [(label: String, value: TimeInterval)] = [
        ("15 seconds", 15),
        ("30 seconds", 30),
        ("1 minute", 60),
        ("2 minutes", 120),
        ("5 minutes", 300),
    ]

    let amountOptions: [(label: String, value: Int)] = [
        ("Subtle (1px)", 1),
        ("Small (3px)", 3),
        ("Medium (5px)", 5),
        ("Noticeable (10px)", 10),
    ]

    func start() {
        isActive = true
        isPaused = false
        scheduleTimer()
    }

    func stop() {
        isActive = false
        isPaused = false
        timer?.invalidate()
        timer = nil
    }

    func togglePause() {
        isPaused.toggle()
        if isPaused {
            timer?.invalidate()
            timer = nil
        } else {
            scheduleTimer()
        }
    }

    func updateInterval(_ newInterval: TimeInterval) {
        interval = newInterval
        if isActive && !isPaused {
            scheduleTimer()
        }
    }

    private func scheduleTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.jiggle()
        }
    }

    private func jiggle() {
        guard CGPreflightPostEventAccess() else { return }

        let event = CGEvent(source: nil)
        guard let location = event?.location else { return }

        let offset = CGFloat(jiggleAmount)

        let moveOut = CGEvent(
            mouseEventSource: nil,
            mouseType: .mouseMoved,
            mouseCursorPosition: CGPoint(x: location.x + offset, y: location.y + offset),
            mouseButton: .left
        )
        moveOut?.post(tap: .cghidEventTap)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let moveBack = CGEvent(
                mouseEventSource: nil,
                mouseType: .mouseMoved,
                mouseCursorPosition: location,
                mouseButton: .left
            )
            moveBack?.post(tap: .cghidEventTap)
        }

        DispatchQueue.main.async {
            self.lastJiggleTime = Date()
        }
    }
}

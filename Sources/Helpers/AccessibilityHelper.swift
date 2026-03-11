import Foundation
import ApplicationServices
import Combine

class AccessibilityHelper: ObservableObject {
    @Published var isGranted = false

    private var timer: Timer?

    init() {
        // Delay initial check to let the app fully launch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.checkPermission()
            self?.startPolling()
        }
    }

    func checkPermission() {
        let trusted = AXIsProcessTrusted()
        if trusted != isGranted {
            isGranted = trusted
        }
    }

    func requestPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
        AXIsProcessTrustedWithOptions(options)
    }

    private func startPolling() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkPermission()
        }
    }

    deinit {
        timer?.invalidate()
    }
}

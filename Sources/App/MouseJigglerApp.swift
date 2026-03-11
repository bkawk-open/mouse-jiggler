import SwiftUI

@main
struct MouseJigglerApp: App {
    @StateObject private var jiggler = MouseJigglerModel()
    @StateObject private var accessibility = AccessibilityHelper()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(jiggler: jiggler, accessibility: accessibility)
                .onAppear {
                    if !hasCompletedOnboarding {
                        NSApp.activate(ignoringOtherApps: true)
                        NSApp.sendAction(Selector(("showOnboarding:")), to: nil, from: nil)
                    }
                }
        } label: {
            Image(systemName: menuBarIcon)
                .symbolEffect(.pulse, isActive: jiggler.isActive && !jiggler.isPaused)
        }
        .menuBarExtraStyle(.window)

        Window("Welcome to Mouse Jiggler", id: "onboarding") {
            OnboardingView()
        }
        .windowResizability(.contentSize)

        Window("About Mouse Jiggler", id: "about") {
            AboutView()
        }
        .windowResizability(.contentSize)

        Settings {
            SettingsView(jiggler: jiggler)
        }
    }

    private var menuBarIcon: String {
        if !accessibility.isGranted {
            return "exclamationmark.triangle"
        }
        return jiggler.isActive ? "computermouse.fill" : "computermouse"
    }
}

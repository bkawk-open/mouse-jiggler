import SwiftUI

struct OnboardingView: View {
    @StateObject private var accessibility = AccessibilityHelper()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "computermouse.fill")
                .font(.system(size: 64))
                .foregroundStyle(.blue)

            Text("Welcome to Mouse Jiggler")
                .font(.largeTitle)
                .bold()

            Text("Keep your Mac awake by subtly moving the mouse at regular intervals. No one will ever know.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 360)

            Divider()
                .frame(maxWidth: 300)

            // Permission section
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: accessibility.isGranted ? "checkmark.circle.fill" : "lock.circle")
                        .font(.title2)
                        .foregroundStyle(accessibility.isGranted ? .green : .orange)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Accessibility Permission")
                            .font(.headline)
                        Text(accessibility.isGranted
                             ? "Permission granted — you're all set!"
                             : "Required to move the mouse cursor")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }
                .frame(maxWidth: 360)

                if !accessibility.isGranted {
                    Button("Grant Permission") {
                        accessibility.requestPermission()
                    }
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                }
            }

            Spacer()

            Button("Get Started") {
                hasCompletedOnboarding = true
                dismiss()
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .disabled(!accessibility.isGranted)

            Spacer()
        }
        .padding(32)
        .frame(width: 500, height: 480)
    }
}

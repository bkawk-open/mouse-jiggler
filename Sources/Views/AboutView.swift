import SwiftUI

struct AboutView: View {
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    private let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "computermouse.fill")
                .font(.system(size: 48))
                .foregroundStyle(.blue)

            Text("Mouse Jiggler")
                .font(.title)
                .bold()

            Text("Version \(version) (\(build))")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Keep your Mac awake with subtle mouse movements.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Divider()

            Text("© 2026 bkawk. All rights reserved.")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(32)
        .frame(width: 320, height: 300)
    }
}

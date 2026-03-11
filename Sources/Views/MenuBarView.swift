import SwiftUI

struct MenuBarView: View {
    @ObservedObject var jiggler: MouseJigglerModel
    @ObservedObject var accessibility: AccessibilityHelper
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: "computermouse.fill")
                    .font(.title2)
                Text("Mouse Jiggler")
                    .font(.headline)
                Spacer()
            }
            .padding(.bottom, 4)

            Divider()

            // Permission warning
            if !accessibility.isGranted {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.yellow)
                    Text("Accessibility permission required")
                        .font(.caption)
                    Spacer()
                }

                Button("Grant Permission") {
                    accessibility.requestPermission()
                }
                .controlSize(.small)

                Divider()
            }

            // Status
            HStack {
                Circle()
                    .fill(statusColor)
                    .frame(width: 8, height: 8)
                Text(statusText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            }

            if let lastTime = jiggler.lastJiggleTime {
                HStack {
                    Text("Last jiggle:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(lastTime, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            // Interval picker
            VStack(alignment: .leading, spacing: 6) {
                Text("Interval")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Picker("Interval", selection: $jiggler.interval) {
                    ForEach(jiggler.intervalOptions, id: \.value) { option in
                        Text(option.label).tag(option.value)
                    }
                }
                .labelsHidden()
                .onChange(of: jiggler.interval) { _, newValue in
                    jiggler.updateInterval(newValue)
                }
            }

            // Amount picker
            VStack(alignment: .leading, spacing: 6) {
                Text("Movement")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Picker("Movement", selection: $jiggler.jiggleAmount) {
                    ForEach(jiggler.amountOptions, id: \.value) { option in
                        Text(option.label).tag(option.value)
                    }
                }
                .labelsHidden()
            }

            Divider()

            // Controls
            HStack(spacing: 8) {
                if jiggler.isActive {
                    Button(action: { jiggler.togglePause() }) {
                        Label(
                            jiggler.isPaused ? "Resume" : "Pause",
                            systemImage: jiggler.isPaused ? "play.fill" : "pause.fill"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .controlSize(.large)

                    Button(role: .destructive, action: { jiggler.stop() }) {
                        Label("Stop", systemImage: "stop.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .controlSize(.large)
                } else {
                    Button(action: { jiggler.start() }) {
                        Label("Start Jiggling", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .disabled(!accessibility.isGranted)
                }
            }

            Divider()

            // Footer links
            HStack {
                Button("About") {
                    NSApp.activate(ignoringOtherApps: true)
                    openWindow(id: "about")
                }
                .font(.subheadline)
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)

                Spacer()

                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .font(.subheadline)
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(width: 260)
    }

    private var statusColor: Color {
        if !accessibility.isGranted { return .red }
        if !jiggler.isActive { return .gray }
        if jiggler.isPaused { return .yellow }
        return .green
    }

    private var statusText: String {
        if !accessibility.isGranted { return "Permission needed" }
        if !jiggler.isActive { return "Inactive" }
        if jiggler.isPaused { return "Paused" }
        return "Active — jiggling every \(Int(jiggler.interval))s"
    }
}

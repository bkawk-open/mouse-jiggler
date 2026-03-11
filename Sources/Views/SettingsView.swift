import SwiftUI

struct SettingsView: View {
    @ObservedObject var jiggler: MouseJigglerModel
    @State private var launchAtLogin = LaunchAtLoginHelper.isEnabled

    var body: some View {
        Form {
            Section("Jiggle Settings") {
                Picker("Interval", selection: $jiggler.interval) {
                    ForEach(jiggler.intervalOptions, id: \.value) { option in
                        Text(option.label).tag(option.value)
                    }
                }
                .onChange(of: jiggler.interval) { _, newValue in
                    jiggler.updateInterval(newValue)
                }

                Picker("Movement", selection: $jiggler.jiggleAmount) {
                    ForEach(jiggler.amountOptions, id: \.value) { option in
                        Text(option.label).tag(option.value)
                    }
                }
            }

            Section("General") {
                Toggle("Launch at Login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { _, _ in
                        LaunchAtLoginHelper.toggle()
                        launchAtLogin = LaunchAtLoginHelper.isEnabled
                    }
            }
        }
        .formStyle(.grouped)
        .frame(width: 380, height: 220)
    }
}

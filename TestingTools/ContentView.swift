import SwiftUI

import AppKit


struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(.testingToolsIcon)
                    .resizable()
                    .scaledToFit().frame(width: 60, height: 60)
                Text("Testing Tools")
                    .font(.largeTitle)
            }
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("How do I install it?")
                        .font(.headline)
                    HStack(spacing: 1) {
                        Text("1. Open System Settings (")
                        Button("System Settings") {
                            openExtensionsPane()
                        }
                        Text(")")
                    }
                    Text("2. Select \"General\" and Navigate to \"Login Items & Extensions\"")
                    Text("3. Below \"Extensions\", select the ⓘ next to \"Xcode Source Editor\"")
                    Text("4. Enable \"TestingTools\"")
                    Text("5. Relaunch Xcode")
                }
                Spacer()
            }
        }
        .padding()
    }
}

func openExtensionsPane() {
    guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.extensions") else {
        return
    }
    NSWorkspace.shared.open(url)
}

#Preview {
    ContentView()
}

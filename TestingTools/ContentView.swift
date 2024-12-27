import SwiftUI

import AppKit

func openExtensionsPane() {
    guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.extensions") else {
        return
    }
    NSWorkspace.shared.open(url)
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Image(.testingToolsIcon)
                    .resizable()
                    .scaledToFit().frame(width: 100, height: 100)
                Text("Testing Tools")
                    .font(.largeTitle)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("How to Enable")
                        .font(.headline)
                    Text("")
                    Button("Open System Settings") {
                        openExtensionsPane()
                    }
                    Text("• Select 'General'")
                    Text("• Navigate to 'Login Items & Extensions'")
                    Text("• Select 'Xcode Source Editor'")
                    Text("• Enable 'Testing Tools'")
                }
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .frame(width: 600, height: 600)
}

import SwiftUI

import AppKit


struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(.testingToolsIcon)
                    .resizable()
                    .scaledToFit().frame(width: 80, height: 80)
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

func openExtensionsPane() {
    guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.extensions") else {
        return
    }
    NSWorkspace.shared.open(url)
}

#Preview {
    ContentView()
        .frame(width: 400, height: 300)
}

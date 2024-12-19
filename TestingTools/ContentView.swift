import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(.testingToolsIcon)
                .resizable()
                .scaledToFit().frame(width: 100, height: 100)
            Text("Testing Tools")
                .font(.largeTitle)
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .frame(width: 600, height: 600)
}

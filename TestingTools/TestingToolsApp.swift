//
//  TestingToolsApp.swift
//  TestingTools
//
//  Created by Andy Brown on 23/11/2024.
//

import SwiftUI

@main
struct TestingToolsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 480, height: 270)
        }
        .windowResizability(.contentSize)
    }
}

//
//  TestingToolsTests.swift
//  TestingToolsTests
//
//  Created by Andy Brown on 24/11/2024.
//

import Testing
import XcodeKit
@testable import TestingToolsExtension

struct CreateType {
    func create(from: NSMutableArray) -> NSMutableArray {
        return ["Hello, world!"]
    }
}

struct TestingToolsTests {
    @Test func example() async throws {
        let input = NSMutableArray()
        
        let output = CreateType().create(from: input)
        
        #expect(output == NSMutableArray(array: ["Hello, world!"]))
    }
}
// IN PROGRESS:
// Exploration: When I pass NSMutableArray (empty), then I get one back with one string: Hello, world! ✅

// TODO:
// Exploration: When I invoke command on blank file, it adds a comment at beginning of file: // input: "" // output: "Hello, world!"
// I am able to highlight some text and make a struct with that name: // input: MyTestClass // output: struct MyTestClass { }

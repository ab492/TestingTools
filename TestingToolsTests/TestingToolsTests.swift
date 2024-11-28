//
//  TestingToolsTests.swift
//  TestingToolsTests
//
//  Created by Andy Brown on 24/11/2024.
//

import Testing
import XcodeKit
@testable import TestingToolsExtension

func createStruct(allText: [String]) -> String {
    "struct TestStruct { }"
}

struct TestingToolsTests {
    @Test func oneWord_withThatWordSelected_correctlyCreatesStruct() {
        let text = ["TestStruct"]
        
        let sut = createStruct(allText: text)
        
        #expect(sut == "struct TestStruct { }")
    }
}

// TODO:
// I am able to highlight some text and make a struct with that name: // input: MyTestClass // output: struct MyTestClass { } ⬅️

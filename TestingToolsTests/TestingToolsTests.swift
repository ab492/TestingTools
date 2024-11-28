//
//  TestingToolsTests.swift
//  TestingToolsTests
//
//  Created by Andy Brown on 24/11/2024.
//

import Testing
import XcodeKit
@testable import TestingToolsExtension

func createStruct(allText: [String], selectedText: XCSourceTextRange) -> String {
    let line = allText[selectedText.start.line]
    
    let startIndex = line.index(line.startIndex, offsetBy: selectedText.start.column)
    let endIndex = line.index(line.startIndex, offsetBy: selectedText.end.column)
    let selectedWord = String(line[startIndex..<endIndex])
    
    return "struct \(selectedWord) { }"
}

struct TestingToolsTests {
    @Test func oneWord_withThatWordSelected_correctlyCreatesStruct() {
        let text = ["TestStruct"]
        let selectedText = XCSourceTextRange(
            start: XCSourceTextPosition(line: 0, column: 0),
            end: XCSourceTextPosition(line: 0, column: 10)
        )
        
        let sut = createStruct(allText: text, selectedText: selectedText)
        
        #expect(sut == "struct TestStruct { }")
    }
}

// TODO:
// I am able to highlight some text and make a struct with that name: // input: MyTestClass // output: struct MyTestClass { } ⬅️

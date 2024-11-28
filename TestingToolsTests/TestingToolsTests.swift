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
    @Test func selectingWordInTheMiddleOfLine_correctlyCreatesStruct() {
        let text = ["let sut = TestStruct()"]
        let rangeOfTestStruct = XCSourceTextRange(
            start: XCSourceTextPosition(line: 0, column: 10),
            end: XCSourceTextPosition(line: 0, column: 20)
        )
        
        let sut = createStruct(allText: text, selectedText: rangeOfTestStruct)

        #expect(sut == "struct TestStruct { }")
    }
}

// TODO:
// I am able to highlight some text and make a struct with that name: // input: MyTestClass // output: struct MyTestClass { } ✅
// If I pass in more than one selection, an error is thrown. ⬅️
// If I pass in multiple line selection, an error is thrown

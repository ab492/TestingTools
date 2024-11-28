//
//  TestingToolsTests.swift
//  TestingToolsTests
//
//  Created by Andy Brown on 24/11/2024.
//

import Testing
import XcodeKit
@testable import TestingToolsExtension

enum TestingToolsError: Error {
    case multipleSelectionNotSupported
    case multilineSelectionNotSupported
}

func createStruct(allText: [String], selectedText: [XCSourceTextRange]) throws -> String? {
    let numberOfSelectedItems = selectedText.count
    
    guard numberOfSelectedItems == 1 else {
        throw TestingToolsError.multipleSelectionNotSupported
    }

    let selectedText = selectedText.first!
    
    let selectionIsMultiline = selectedText.start.line != selectedText.end.line
    if selectionIsMultiline {
        throw TestingToolsError.multilineSelectionNotSupported
    }
    
    let line = allText[selectedText.start.line]
    
    let startIndex = line.index(line.startIndex, offsetBy: selectedText.start.column)
    let endIndex = line.index(line.startIndex, offsetBy: selectedText.end.column)
    let selectedWord = String(line[startIndex..<endIndex])
    
    return "struct \(selectedWord) { }"
}

struct TestingToolsTests {
    @Test func selectingWordInTheMiddleOfLine_correctlyCreatesStruct() throws {
        let text = ["let sut = TestStruct()"]
        let rangeOfTestStruct = XCSourceTextRange(
            start: XCSourceTextPosition(line: 0, column: 10),
            end: XCSourceTextPosition(line: 0, column: 20)
        )
        
        let sut = try createStruct(allText: text, selectedText: [rangeOfTestStruct])

        #expect(sut == "struct TestStruct { }")
    }
    
    @Test func multipleSelectedText_throwsError() {
        let text = ["let sut = TestStruct()"]
        let firstSelection = XCSourceTextRange(
            start: XCSourceTextPosition(line: 0, column: 0),
            end: XCSourceTextPosition(line: 0, column: 3)
        )
        let secondSelection = XCSourceTextRange(
            start: XCSourceTextPosition(line: 0, column: 5),
            end: XCSourceTextPosition(line: 0, column: 10)
        )
        
        #expect(throws: TestingToolsError.multipleSelectionNotSupported) {
            try createStruct(allText: text, selectedText: [firstSelection, secondSelection])
        }
    }
    
    @Test func multipleLineSelectedText_throwsError() {
        let text = ["let sut = TestStruct()"]
        let multipleLineSelection = XCSourceTextRange(
            start: XCSourceTextPosition(line: 0, column: 0),
            end: XCSourceTextPosition(line: 1, column: 10)
        )
        
        #expect(throws: TestingToolsError.multilineSelectionNotSupported) {
            try createStruct(allText: text, selectedText: [multipleLineSelection])
        }
    }
}

// TODO:
// I am able to highlight some text and make a struct with that name: // input: MyTestClass // output: struct MyTestClass { } ✅
// If I pass in more than one selection, an error is thrown. ✅
// If I pass in multiple line selection, an error is thrown ✅
// If I pass a selection into an empty page, nil is returned
// If selection doesn't exist in page, nil is returned

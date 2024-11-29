//
//  TestingToolsTests.swift
//  TestingToolsTests
//
//  Created by Andy Brown on 24/11/2024.
//

import Testing
import XcodeKit
@testable import TestingToolsExtension

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
    
    @Test func passingASelectionWhenNoText_returnsNil() throws {
        let emptyPage = [String]()
        let aSelection = XCSourceTextRange(
            start: XCSourceTextPosition(line: 0, column: 0),
            end: XCSourceTextPosition(line: 0, column: 10)
        )
        
        let sut = try createStruct(allText: emptyPage, selectedText: [aSelection])

        #expect(sut == nil, "This doesn't throw an error since it's not really a situation that should happen")
    }
    
    @Test func passingASelectionThatDoesntExistOnPage_returnsNil() throws {
        let text = ["let sut = TestStruct()"]
        let nonExistentSelection = XCSourceTextRange(
            start: XCSourceTextPosition(line: 1, column: 0),
            end: XCSourceTextPosition(line: 1, column: 10)
        )
        
        let sut = try createStruct(allText: text, selectedText: [nonExistentSelection])
        
        #expect(sut == nil, "This doesn't throw an error since it's not really a situation that should happen")
    }
    
    @Test func selectingWordInMultilinePage_returnsStruct() throws {
        let text = [
            "let sut = TestStruct()",
            "   let anotherSut = AnotherStruct()"
        ]
        let rangeOfAnotherStruct = XCSourceTextRange(
            start: XCSourceTextPosition(line: 1, column: 20),
            end: XCSourceTextPosition(line: 1, column: 33)
        )
        
        let sut = try createStruct(allText: text, selectedText: [rangeOfAnotherStruct])

        #expect(sut == "struct AnotherStruct { }")
    }
}

// TODO:
// I am able to highlight some text and make a struct with that name: // input: MyTestClass // output: struct MyTestClass { } ✅
// If I pass in more than one selection, an error is thrown. ✅
// If I pass in multiple line selection, an error is thrown ✅
// If I pass a selection into an empty page, nil is returned ✅
// If selection doesn't exist in page, nil is returned ✅
// Empty selection, nil is returned ❌ Don't think this is required
// If I have a multiline page and I select a struct, it will be created.

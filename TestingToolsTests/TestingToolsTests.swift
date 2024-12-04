//
//  TestingToolsTests.swift
//  TestingToolsTests
//
//  Created by Andy Brown on 24/11/2024.
//

import Testing
import XcodeKit
@testable import Testing_Tools

struct TestingToolsTests {
    struct StructWithNoPropertiesTests {
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
    
    struct StructWithProperties {
        @Test func selectingStructWithStringInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someString: \"Hello\")"]
            let rangeOfTestStruct = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 10), // Start of "TestStruct"
                end: XCSourceTextPosition(line: 0, column: 41)   // End of "(someString: \"Hello\")"
            )
            
            let sut = try createStruct(allText: text, selectedText: [rangeOfTestStruct])
            
            let expectedValue = """
            struct TestStruct {
                let someString: String
            }
            """
            #expect(sut == expectedValue)
        }
        
        @Test func selectingStructWithIntInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someInt: 42)"]
            let rangeOfTestStruct = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 10),
                end: XCSourceTextPosition(line: 0, column: 33)
            )
            
            let sut = try createStruct(allText: text, selectedText: [rangeOfTestStruct])
            
            let expectedValue = """
            struct TestStruct {
                let someInt: Int
            }
            """
            #expect(sut == expectedValue)
        }
        
        @Test func selectingStructWithDoubleInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someDouble: 3.14)"]
            let rangeOfTestStruct = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 10),
                end: XCSourceTextPosition(line: 0, column: 38)
            )
            
            let sut = try createStruct(allText: text, selectedText: [rangeOfTestStruct])
            
            let expectedValue = """
            struct TestStruct {
                let someDouble: Double
            }
            """
            #expect(sut == expectedValue)
        }
    }
    
}



// TODO
// Guard that struct is passed in correctly with opening and closing brackets
// Add tests for int ⬅️
// Add test for bool
// Add tests for double
// Add tests for unknown
// Add tests for multiple parameters

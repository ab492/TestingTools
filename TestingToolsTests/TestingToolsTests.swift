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
    struct CreatingObjectTests {
        @Test("Selecting 'TestStruct'")
        func selectingWordExludingBrackets_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct()"]
            let rangeOfTestStruct = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 10),
                end: XCSourceTextPosition(line: 0, column: 20)
            )
            
            let sut = try createStruct(allText: text, selectedText: [rangeOfTestStruct])
            
            #expect(sut == "struct TestStruct { }")
        }
        
        @Test("Selecting 'TestStruct()'")
        func selectingWordIncludingBrackets_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct()"]
            let rangeOfTestStruct = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 10),
                end: XCSourceTextPosition(line: 0, column: 22)
            )
            
            let sut = try createStruct(allText: text, selectedText: [rangeOfTestStruct])
            
            #expect(sut == "struct TestStruct { }")
        }
        
        func selectingStructWithStringInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someString: \"Hello\")"]
            let rangeOfTestStruct = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 10),
                end: XCSourceTextPosition(line: 0, column: 41)
            )
            
            let sut = try createStruct(allText: text, selectedText: [rangeOfTestStruct])
            
            let expectedValue = """
            struct TestStruct {
                let someString: String
            }
            """
            #expect(sut == expectedValue)
        }
        
        func selectingStructWithIntInInit_correctlyCreatesStruct() throws {
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
        
        func selectingStructWithDoubleInInit_correctlyCreatesStruct() throws {
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
        
        @Test func selectingStructWithBoolInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someBool: true)"]
            let rangeOfTestStruct = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 10),
                end: XCSourceTextPosition(line: 0, column: 36)
            )
            
            let sut = try createStruct(allText: text, selectedText: [rangeOfTestStruct])
            
            let expectedValue = """
            struct TestStruct {
                let someBool: Bool
            }
            """
            #expect(sut == expectedValue)
        }
        
        @Test("Unknown type should expand to editor placeholder - unicode characters required to prevent placeholder expanding in tests")
        func selectingStructWithUnknownParamerInInit_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someUnknown: unknownProperty)"]
            let rangeOfTestStruct = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 10),
                end: XCSourceTextPosition(line: 0, column: 50)
            )
            
            let sut = try createStruct(allText: text, selectedText: [rangeOfTestStruct])
            
            let expectedValue = """
            struct TestStruct {
                let someUnknown: \u{003C}#Type#\u{003E}
            }
            """
            #expect(sut == expectedValue)
        }
        
        @Test func selectingStructWithMultipleParameters_correctlyCreatesStruct() throws {
            let text = ["let sut = TestStruct(someBool: true, someInt: 42)"]
            let rangeOfTestStruct = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 10),
                end: XCSourceTextPosition(line: 0, column: 49)
            )
            
            
            let sut = try createStruct(allText: text, selectedText: [rangeOfTestStruct])
            
            let expectedValue = """
            struct TestStruct {
                let someBool: Bool
                let someInt: Int
            }
            """
            #expect(sut == expectedValue)
        }
    }
    
    
    struct ErrorTests {
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
        
        @Test("Selecting 'TestStruct(someInt:'")
        func halfSelectingStructWithProperties_throwsError() throws {
            let text = ["let sut = TestStruct(someInt: 42)"]
            let rangeOfTestStruct = XCSourceTextRange(
                start: XCSourceTextPosition(line: 0, column: 10),
                end: XCSourceTextPosition(line: 0, column: 29)
            )
            
            #expect(throws: TestingToolsError.invalidSelection) {
                try createStruct(allText: text, selectedText: [rangeOfTestStruct])
            }
        }
    }
}

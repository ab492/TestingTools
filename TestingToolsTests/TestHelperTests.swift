//
//  TestHelperTests.swift
//  TestingToolsTests
//
//  Created by Andy Brown on 05/12/2024.
//

import Testing
import XcodeKit

struct TestHelperTests {
    @Test func getRangeOfTextWorksCorrectly()  {
        let text = [
            "let sut = TestStruct()",
            "   let anotherSut = AnotherStruct()"
        ]
        let expectedRange = XCSourceTextRange(
            start: XCSourceTextPosition(line: 1, column: 20),
            end: XCSourceTextPosition(line: 1, column: 33)
        )
        
        let rangeOfText = getRangeOfText("AnotherStruct", from: text)

        #expect(rangeOfText == expectedRange)
    }
    
    @Test func combineRangesWorksCorrectly() {
        let firstRange = XCSourceTextRange(
            start: XCSourceTextPosition(line: 1, column: 20),
            end: XCSourceTextPosition(line: 1, column: 33)
        )
        let secondRange = XCSourceTextRange(
            start: XCSourceTextPosition(line: 2, column: 1),
            end: XCSourceTextPosition(line: 2, column: 40)
        )
        
        let combinedRange = combineRanges(firstRange, secondRange)
        
        #expect(
            combinedRange == XCSourceTextRange(
                start: XCSourceTextPosition(line: 1, column: 20),
                end: XCSourceTextPosition(line: 2, column: 40)
            )
        )
    }
}

/// Gets the `XCSourceTextRange` from an array of strings, which represents a page of text where each index is a line.
func getRangeOfText(_ text: String, from allText: [String]) -> XCSourceTextRange? {
    for (lineIndex, line) in allText.enumerated() {
        if let range = line.range(of: text) {
            let start = XCSourceTextPosition(line: lineIndex, column: line.distance(from: line.startIndex, to: range.lowerBound))
            let end = XCSourceTextPosition(line: lineIndex, column: line.distance(from: line.startIndex, to: range.upperBound))
            return XCSourceTextRange(start: start, end: end)
        }
    }
    
    return nil
}

func combineRanges(_ first: XCSourceTextRange, _ second: XCSourceTextRange) -> XCSourceTextRange {
    let combinedStart = first.start
    let combinedEnd = second.end
    return XCSourceTextRange(start: combinedStart, end: combinedEnd)
}

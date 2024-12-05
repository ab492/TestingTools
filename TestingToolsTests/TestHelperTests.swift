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
        let text = ["let sut = TestStruct(someBool: true, someInt: 42)"]
        let expectedRange = XCSourceTextRange(
            start: XCSourceTextPosition(line: 0, column: 10),
            end: XCSourceTextPosition(line: 0, column: 49)
        )
        
        let rangeOfText = getRangeOfText("TestStruct(someBool: true, someInt: 42)", from: text)

        #expect(rangeOfText == expectedRange)
    }
}

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





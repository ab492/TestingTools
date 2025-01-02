import Testing
import XcodeKit

func createProperty(allText: [String], selectedText: [XCSourceTextRange]) throws -> [String] {
    guard let selectedText = selectedText.first else {
        throw TestingToolsError.invalidSelection
    }
    
    guard selectedText.start.line == selectedText.end.line else {
        throw TestingToolsError.multilineSelectionNotSupported
    }
    
    guard let lineContainingSelection = allText[safe: selectedText.start.line] else { return [] } // return nil instead
    let selectionStartIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.start.column)
    let selectionEndIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.end.column)
    let propertyName = String(lineContainingSelection[selectionStartIndex..<selectionEndIndex])
    
    // Count the leading whitespace so we can preserve indentation
    let selectedLineIndex = selectedText.start.line
    let leadingWhitespaceCount = lineContainingSelection.prefix(while: { $0 == " "}).count
    let leadingWhitespace = String(repeating: " ", count: leadingWhitespaceCount)
    let newLine = leadingWhitespace + "let \(propertyName) =\u{003C}#Type#\u{003E}\n"
    
    // Insert the new line right before the line that uses the property
    var modifiedText = allText
    modifiedText.insert(newLine, at: selectedLineIndex)
    
    return modifiedText
}

struct CreatePropertyTests {
    
    @Test func testCreatingLocalProperty() throws {
        let text = [
            "struct TestStruct {\n",
            "    func someDummyMethod() {\n",
            "        someProperty.callSomeMethod()\n",
            "    }\n",
            "}\n"
        ]
        let highlightedText = getRangeOfText("someProperty", from: text)!

        
        let sut = try createProperty(allText: text, selectedText: [highlightedText])
        
        #expect(sut == [
            "struct TestStruct {\n",
            "    func someDummyMethod() {\n",
            "        let someProperty =\u{003C}#Type#\u{003E}\n",
            "        someProperty.callSomeMethod()\n",
            "    }\n",
            "}\n"
        ])
    }
    
    @Test func testErrorIsThrownIfNoSelectionIsMade() {
        let text = [
            "struct TestStruct {\n",
            "    someProperty.callSomeMethod()\n",
            "}\n"
        ]
        
        #expect(throws: TestingToolsError.invalidSelection) {
            try createProperty(allText: text, selectedText: [])
        }
    }
    
    func multipleSelectedText_throwsError() {
        let text = [
            "struct TestStruct {\n",
            "    someProperty.callSomeMethod()\n",
            "}\n"
        ]
        let firstSelection = XCSourceTextRange(
            start: XCSourceTextPosition(line: 0, column: 0),
            end: XCSourceTextPosition(line: 0, column: 3)
        )
        let secondSelection = XCSourceTextRange(
            start: XCSourceTextPosition(line: 0, column: 5),
            end: XCSourceTextPosition(line: 0, column: 10)
        )
        
        #expect(throws: TestingToolsError.multipleSelectionNotSupported) {
            try createProperty(allText: text, selectedText: [firstSelection, secondSelection])
        }
    }
    
    @Test func multipleLineSelectedText_throwsError() {
        let text = [
            "struct TestStruct {\n",
            "    someProperty.callSomeMethod()\n",
            "}\n"
        ]
        let multipleLineSelection = XCSourceTextRange(
            start: XCSourceTextPosition(line: 0, column: 0),
            end: XCSourceTextPosition(line: 1, column: 10)
        )
        
        #expect(throws: TestingToolsError.multilineSelectionNotSupported) {
            try createProperty(allText: text, selectedText: [multipleLineSelection])
        }
    }
}

// TODO
// Create local variable ✅
// Throw error if can't get selected text ✅
// Throw error if multiline selection ✅
// Throw error if highlight isn't valid (doesn't include .?). Maybe this is just check the highlighted text doesn't contain invalid characters?
// Test nested create local property ⬅️
// Selected text contains multiple text ✅
// Look into how to handle \t characters (instead of spaces)

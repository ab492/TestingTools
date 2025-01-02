import Testing
import XcodeKit

func createProperty(allText: [String], selectedText: [XCSourceTextRange], tabWidth: Int) throws -> [String] {
    
    guard let selectedText = selectedText.first else {
        throw TestingToolsError.invalidSelection
    }
    
    let selectedLineIndex = selectedText.start.line
//    let propertyName = selectedText
    
    guard let lineContainingSelection = allText[safe: selectedText.start.line] else { return [] } // return nil instead
    let selectionStartIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.start.column)
    let selectionEndIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.end.column)
    let propertyName = String(lineContainingSelection[selectionStartIndex..<selectionEndIndex])
    
 
    
    // Extract the property name: e.g., "someProperty"
    let originalLine = allText[selectedLineIndex]
    

    // Count the leading spaces/tabs of the line so we can preserve indentation
    let leadingWhitespaceCount = originalLine.prefix(while: { $0 == " " || $0 == "\t" }).count
    let leadingWhitespace = String(repeating: " ", count: leadingWhitespaceCount)
    
    // Create a new line: "    let someProperty =\n"
    let newLine = leadingWhitespace + "let \(propertyName) =\n"
    
    // Insert the new line right before the line that uses the property
    var modifiedText = allText
    modifiedText.insert(newLine, at: selectedLineIndex)
    
    return modifiedText
}

struct CreatePropertyTests {
    @Test func testCreatingLocalProperty() throws {
        let text = [
            "struct TestStruct {\n",
            "    someProperty.callSomeMethod()\n",
            "}\n"
        ]
        let highlightedText = getRangeOfText("someProperty", from: text)!

        
        let sut = try createProperty(allText: text, selectedText: [highlightedText], tabWidth: 4)
        
        #expect(sut == [
            "struct TestStruct {\n",
            "    let someProperty =\n",
            "    someProperty.callSomeMethod()\n",
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
            try createProperty(allText: text, selectedText: [], tabWidth: 4)
        }
    }
    
}

// TODO
// Create local variable ✅
// Throw error if can't get selected text ✅
// Throw error if multiline selection
// Throw error if highlight isn't valid (doesn't include .?). Maybe this is just check the highlighted text doesn't contain invalid characters?



//struct TestStruct {
//    func foo() {
//        someProperty.callSomeMethod()
//    }
//}

//
//guard numberOfSelectedItems == 1,
//      let selectedText = selectedText.first else {
//    throw TestingToolsError.multipleSelectionNotSupported
//}
//
//guard selectedText.start.line == selectedText.end.line else {
//    throw TestingToolsError.multilineSelectionNotSupported
//}

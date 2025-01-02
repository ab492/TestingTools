import Testing
import XcodeKit

func createProperty(allText: [String], selectedText: [XCSourceTextRange], tabWidth: Int) -> [String] {
    // If there's no selection or the lines are out of range, just return original
    guard let highlight = selectedText.first,
          highlight.start.line < allText.count
    else {
        return allText
    }
    
    // For simplicity, assume highlight.end.line == highlight.start.line
    let lineIndex = highlight.start.line
    let startColumn = highlight.start.column
    let endColumn = highlight.end.column
    
    // Extract the property name: e.g., "someProperty"
    let originalLine = allText[lineIndex]
    let nsstring = originalLine as NSString
    
    // The length of the highlighted text
    let length = endColumn - startColumn
    guard length > 0, startColumn + length <= originalLine.count else {
        return allText
    }
    let propertyName = nsstring.substring(with: NSRange(location: startColumn, length: length))
    
    // Count the leading spaces/tabs of the line so we can preserve indentation
    let leadingWhitespaceCount = originalLine.prefix(while: { $0 == " " || $0 == "\t" }).count
    let leadingWhitespace = String(repeating: " ", count: leadingWhitespaceCount)
    
    // Create a new line: "    let someProperty =\n"
    let newLine = leadingWhitespace + "let \(propertyName) =\n"
    
    // Insert the new line right before the line that uses the property
    var modifiedText = allText
    modifiedText.insert(newLine, at: lineIndex)
    
    return modifiedText
}

struct CreatePropertyTests {
    @Test func test() {
        let text = [
            "struct TestStruct {\n",
            "    someProperty.callSomeMethod()\n",
            "}\n"
        ]
        let highlightedText = getRangeOfText("someProperty", from: text)!

        
        let sut = createProperty(allText: text, selectedText: [highlightedText], tabWidth: 4)
        
        #expect(sut == [
            "struct TestStruct {\n",
            "    let someProperty =\n",
            "    someProperty.callSomeMethod()\n",
            "}\n"
        ])
    }
    
}

// TODO
// Create local variable ⬅️


//struct TestStruct {
//    func foo() {
//        someProperty.callSomeMethod()
//    }
//}

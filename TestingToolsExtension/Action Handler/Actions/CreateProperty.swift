import Foundation
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
    let newLine = leadingWhitespace + "let \(propertyName) = \u{003C}#Type#\u{003E}\n"
    
    // Insert the new line right before the line that uses the property
    var modifiedText = allText
    modifiedText.insert(newLine, at: selectedLineIndex)
    
    return modifiedText
}

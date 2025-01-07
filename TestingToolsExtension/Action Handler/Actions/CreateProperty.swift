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

func createGlobalProperty(allText: [String], selectedText: [XCSourceTextRange]) throws -> [String] {
    // 1. Ensure there is exactly one selection.
    guard !selectedText.isEmpty else {
        throw TestingToolsError.invalidSelection
    }
    guard selectedText.count == 1 else {
        throw TestingToolsError.multipleSelectionNotSupported
    }

    // 2. Validate the selection is on a single line (no multiline).
    let selection = selectedText[0]
    guard selection.start.line == selection.end.line else {
        throw TestingToolsError.multilineSelectionNotSupported
    }

    // 3. Extract the property name from that single selection.
    guard let lineContainingSelection = allText[safe: selection.start.line] else {
        throw TestingToolsError.invalidSelection
    }
    let startIndex = lineContainingSelection.index(lineContainingSelection.startIndex,
                                                  offsetBy: selection.start.column)
    let endIndex = lineContainingSelection.index(lineContainingSelection.startIndex,
                                                offsetBy: selection.end.column)
    let propertyName = String(lineContainingSelection[startIndex..<endIndex])

    // 4. Build the global property declaration.
    let globalProperty = "let \(propertyName) = <#Type#>\n"

    // 5. Find insertion point after all import lines.
    var insertionIndex = 0
    for (index, line) in allText.enumerated() {
        if line.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("import ") {
            insertionIndex = index + 1
        } else {
            // Once we see a line that's not an `import`, we break.
            break
        }
    }

    // 6. Insert the global property + extra blank line.
    var updatedText = allText
    if insertionIndex < updatedText.count,
       updatedText[insertionIndex].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        insertionIndex += 1
    }
    updatedText.insert(globalProperty, at: insertionIndex)
    updatedText.insert("\n", at: insertionIndex + 1)

    return updatedText
}

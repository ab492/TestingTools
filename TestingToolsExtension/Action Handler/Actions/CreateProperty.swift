import Foundation
import XcodeKit

enum PropertyType {
    case instance
    case local
    case global
}

func createProperty(type: PropertyType, allText: [String], selectedText: [XCSourceTextRange], tabWidth: Int) throws -> [String] {
    if selectedText.count > 1 {
        throw TestingToolsError.multipleSelectionNotSupported
    }
    
    guard let selectedText = selectedText.first else {
        throw TestingToolsError.invalidSelection
    }
    
    guard selectedText.start.line == selectedText.end.line else {
        throw TestingToolsError.multilineSelectionNotSupported
    }
    
    guard let lineContainingSelection = allText[safe: selectedText.start.line] else {
        throw TestingToolsError.invalidSelection
    }
    
    let selectionStartIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.start.column)
    let selectionEndIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.end.column)
    let propertyName = String(lineContainingSelection[selectionStartIndex..<selectionEndIndex])
    let propertyDeclaration = "let \(propertyName) = \u{003C}#Type#\u{003E}\n"
    
    var updatedText = allText
    
    switch type {
    case .global:
        // Find insertion point after all import lines.
        var insertionIndex = 0
        for (index, line) in allText.enumerated() {
            if line.hasPrefix("import ") {
                insertionIndex = index + 1
            } else {
                // Once we find a line that's not an `import`, we break.
                break
            }
        }

        if insertionIndex < updatedText.count,
           updatedText[insertionIndex].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            insertionIndex += 1
        }
        updatedText.insert(propertyDeclaration, at: insertionIndex)
        updatedText.insert("\n", at: insertionIndex + 1)

    case .local:
        // Count the leading whitespace so we can preserve indentation
        let selectedLineIndex = selectedText.start.line
        let leadingWhitespaceCount = lineContainingSelection.prefix(while: { $0 == " "}).count
        let leadingWhitespace = String(repeating: " ", count: leadingWhitespaceCount)
        let newLine = leadingWhitespace + propertyDeclaration
        
        // Insert the new line right before the line that uses the property
        updatedText.insert(newLine, at: selectedLineIndex)
        
    case .instance:
        let indexOfLineWherePropertyUsed = selectedText.start.line
        
        // We want the indentation to match the scope of the enclosing struct or class.
        // These could be nested types themselves, so we work backwards from the index of
        // the selected property to find the class/struct definition.
        
        var structLineIndex: Int? = nil
        for index in stride(from: indexOfLineWherePropertyUsed, through: 0, by: -1) {
            let trimmed = allText[index].trimmingCharacters(in: .whitespacesAndNewlines)
            
            let lineContainsStructOrClass = (trimmed.contains("struct ") || trimmed.contains("class "))
            let isTypeOpening = lineContainsStructOrClass && trimmed.hasSuffix("{")
           
            if isTypeOpening {
                structLineIndex = index
                break
            }
        }
        
        guard let structLineIndex else {
            throw TestingToolsError.noObjectToCreateInstancePropertyOn
        }
        
        let structLine = updatedText[structLineIndex]
        let structIndentCount = structLine.prefix(while: { $0 == " " }).count
        let propertyIndentCount = structIndentCount + tabWidth
        let propertyIndentation = String(repeating: " ", count: propertyIndentCount)
    
        updatedText.insert("\n", at: structLineIndex + 1)
        updatedText.insert(propertyIndentation + propertyDeclaration, at: structLineIndex + 2)
        updatedText.insert("\n", at: structLineIndex + 3)        
    }
    return updatedText
}

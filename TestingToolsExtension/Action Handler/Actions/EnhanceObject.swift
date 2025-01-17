import Foundation
import XcodeKit

func enhanceObject(
    allText: [String],
    selectedText: [XCSourceTextRange],
    tabWidth: Int
) throws -> [String] {
    var result = [String]()
    var updatedText = allText
    
    if selectedText.count > 1 {
        throw TestingToolsError.multipleSelectionNotSupported
    }
    
    guard let selectedText = selectedText.first else {
        throw TestingToolsError.invalidSelection
    }
    let lineContainingSelection = allText[safe: selectedText.start.line]!
    let objectPropertyName = lineContainingSelection.components(separatedBy: ".").first!.trimmingCharacters(in: .whitespaces)
    
    
    let selectionStartIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.start.column)
    let selectionEndIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.end.column)
    let propertyName = String(lineContainingSelection[selectionStartIndex..<selectionEndIndex])

    // Regular expression to match variable definitions (e.g., "let myStruct = ...")
    let pattern = "\\b(let)\\s+\(objectPropertyName)\\b"

    var objectName: String?
    // Search through the lines
    for (index, line) in allText.enumerated() {
        if let _ = line.range(of: pattern, options: .regularExpression) {
            let equalIndex = line.firstIndex(of: "=")!
            let openParenIndex = line.firstIndex(of: "(")!
            let start = line.index(after: equalIndex) // Skip the "="
            let range = start..<openParenIndex
            let result = line[range].trimmingCharacters(in: .whitespaces)
            objectName = result
            print("STRUCT NAME: \(result)")
            
            break
        }
    }
    
    let propertyValue = lineContainingSelection.components(separatedBy: "=").last!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    let propertyDefinition = determinePropertyDefinition(from: propertyValue, propertyName: propertyName)
    
    let structOrClassDefinition = ["struct \(objectName!)", "class \(objectName!)"]
    let structDefinitionLineIndex = allText.firstIndex { line in
        structOrClassDefinition.contains { line.contains($0) }
    }!
    let allTextOnStructDefinitionLine = allText[structDefinitionLineIndex]
    
    let structDefinedOnOneLine = allTextOnStructDefinitionLine.contains(where: { $0 == "{"}) && allTextOnStructDefinitionLine.contains(where: { $0 == "}"})
    
    if structDefinedOnOneLine {
        updatedText[structDefinitionLineIndex] = "struct \(objectName!) {\n"
        updatedText.insert("    \(propertyDefinition)\n", at: structDefinitionLineIndex + 1)
        updatedText.insert("}\n", at: structDefinitionLineIndex + 2)
    } else {
        
        var lastPropertyIndex: Int? = nil

        // Look for lines containing "let " or "var " after structIndex
        for i in (structDefinitionLineIndex + 1)..<allText.count {
            if allText[i].contains("}") {
                // Stop the loop when encountering a closing brace
                break
            }
            if allText[i].contains("let ") || allText[i].contains("var ") {
                lastPropertyIndex = i
            }
        }
        
        if let lastPropertyIndex {
            updatedText.insert("    \(propertyDefinition)\n", at: lastPropertyIndex + 1)

        }
        

        
    }
    
    return updatedText
}

private func determinePropertyDefinition(from value: String, propertyName: String) -> String {
    if Int(value) != nil {
        return "let \(propertyName): Int"
    } else if Double(value) != nil {
        return "let \(propertyName): Double"
    } else if value == "true" || value == "false" {
        return "let \(propertyName): Bool"
    } else if value.hasPrefix("\"") && value.hasSuffix("\"") {
        return "let \(propertyName): String"
    } else {
        return "let \(propertyName): \u{003C}#Type#\u{003E}"
    }
}

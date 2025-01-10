import Foundation
import XcodeKit

func enhanceObject(
    allText: [String],
    selectedText: [XCSourceTextRange],
    tabWidth: Int
) throws -> [String] {
    var result = [String]()
    var updatedText = allText
    
    let selectedText = selectedText.first!
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
    
    let propertyValue = lineContainingSelection.components(separatedBy: "=").last!.trimmingCharacters(in: .whitespaces)
    
    let isInt = Int(propertyValue) != nil
    
//    if let structDefinitionLine = allText.first(where: { $0.contains("struct \(objectName!)")}) {
//        let trimmedLine = structDefinitionLine.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        if trimmedLine == "struct \(objectName!) { }" {
//            // Replace this single line with the multi-line definition
//            result.append("struct \(objectName!) {\n")
//            result.append("    let \(propertyName): Int\n")
//            result.append("}\n")
//        }
//    }
    
    let structDefinition = "struct \(objectName!)"
    let structDefinitionLineIndex = allText.firstIndex(where: { $0.contains(structDefinition)})!
    let allTextOnStructDefinitionLine = allText[structDefinitionLineIndex]
    
    let structDefinedOnOneLine = allTextOnStructDefinitionLine.contains(where: { $0 == "{"}) && allTextOnStructDefinitionLine.contains(where: { $0 == "}"})
    
    if structDefinedOnOneLine {
        updatedText[structDefinitionLineIndex] = "struct \(objectName!) {\n"
        updatedText.insert("    let \(propertyName): Int\n", at: structDefinitionLineIndex + 1)
        updatedText.insert("}\n", at: structDefinitionLineIndex + 2)
    }
    
    
    print("HERE: \(allTextOnStructDefinitionLine)")
    for line in allText {
        // Remove all whitespace & newlines from the start/end.
        let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedLine == "struct \(objectName!) { }" {
            // Replace this single line with the multi-line definition
            result.append("struct \(objectName!) {\n")
            result.append("    let \(propertyName): Int\n")
//            result.append("}\n")
        } else {
            // Keep the line unchanged
            result.append(line)
        }
    }

    return updatedText
}

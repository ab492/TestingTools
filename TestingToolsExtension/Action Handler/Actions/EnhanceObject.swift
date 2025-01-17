import Foundation
import XcodeKit

enum EnhanceObjectError: Error, LocalizedError, CustomNSError {
    case noPropertyToCreate
    case objectNotFound
    case unableToFindObjectDefinition
    
    var localizedDescription: String {
        switch self {
        case .noPropertyToCreate:
            return "No property to create - have you selected a property on an object? (someObject.someProperty = value)"
        case .unableToFindObjectDefinition:
            return "Unable to find object definition. It must exist in this file due to a limitation of Xcode Extensions."
        case .objectNotFound:
            return "Unable to find object definition. Is it initialised?"
        }
    }
    
    var errorUserInfo: [String: Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

func enhanceObject(
    allText: [String],
    selectedText: XCSourceTextRange,
    lineContainingSelection: String,
    tabWidth: Int
) throws -> [String] {
    // Examples will be based on a line like this: someObject.propertyName = somePropertyValue
    
    var updatedText = allText
    
    // someObject.propertyName -> propertyName
    let selectionStartIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.start.column)
    let selectionEndIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.end.column)
    let propertyName = String(lineContainingSelection[selectionStartIndex..<selectionEndIndex])
    
    // someObject.propertyName -> someObject
    let components = lineContainingSelection.trimmingCharacters(in: .whitespaces).components(separatedBy: ".")
    guard components.count > 1, let objectPropertyName = components.first else {
        throw EnhanceObjectError.noPropertyToCreate
    }
    
    // Find where the object is initialised -> "let someObject = ..."
    let pattern = "\\b(let)\\s+\(objectPropertyName)\\b"
    var typeName: String?
    
    for line in allText {
        if line.range(of: pattern, options: .regularExpression) != nil,
           let indexOfEquals = line.firstIndex(of: "="),
           let indexOfOpenParen = line.firstIndex(of: "(") {
            // If we're here, we should have "let someObject = SomeObject()"
            // Now we're trying to just the object name (i.e. SomeObject)
            let objectType = line[line.index(after: indexOfEquals)..<indexOfOpenParen].trimmingCharacters(in: .whitespaces)
            typeName = objectType
            break
        }
    }

    guard let typeName else {
        throw EnhanceObjectError.objectNotFound
    }
//
//    var objectName: String?
//    // Search through the lines
//    for (index, line) in allText.enumerated() {
//        if let _ = line.range(of: pattern, options: .regularExpression) {
//            let equalIndex = line.firstIndex(of: "=")!
//            let openParenIndex = line.firstIndex(of: "(")!
//            let start = line.index(after: equalIndex) // Skip the "="
//            let range = start..<openParenIndex
//            let result = line[range].trimmingCharacters(in: .whitespaces)
//            objectName = result
//            print("STRUCT NAME: \(result)")
//            
//            break
//        }
//    }
//    
    let propertyValue = lineContainingSelection.components(separatedBy: "=").last!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    let propertyDefinition = determinePropertyDefinition(from: propertyValue, propertyName: propertyName)
    
    let structOrClassDefinition = ["struct \(typeName)", "class \(typeName)"]
    let structDefinitionLineIndex = allText.firstIndex { line in
        structOrClassDefinition.contains { line.contains($0) }
    }!
    let allTextOnStructDefinitionLine = allText[structDefinitionLineIndex]
    
    let structDefinedOnOneLine = allTextOnStructDefinitionLine.contains(where: { $0 == "{"}) && allTextOnStructDefinitionLine.contains(where: { $0 == "}"})
    
    if structDefinedOnOneLine {
        updatedText[structDefinitionLineIndex] = "struct \(typeName) {\n"
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

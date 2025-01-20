import Foundation
import XcodeKit

enum EnhanceObjectError: Error, LocalizedError, CustomNSError {
    case noPropertyToCreate
    case objectNotFound
    case unableToFindObjectDefinition
    case unableToFindPropertyValue
    
    var localizedDescription: String {
        switch self {
        case .noPropertyToCreate:
            return "No property to create - have you selected a property on an object? (someObject.someProperty = value)"
        case .unableToFindObjectDefinition:
            return "Unable to find object definition. It must exist in this file due to a limitation of Xcode Extensions."
        case .objectNotFound:
            return "Unable to find object definition. Is it initialised?"
        case .unableToFindPropertyValue:
            return "Unable to find property value. Have you assigned a value to your property name?"
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
    // Examples will be based on a line like this: "someObject.propertyName = somePropertyValue"
    
    var updatedText = allText
    
    // "someObject.propertyName = somePropertyValue" -> "propertyName"
    let selectionStartIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.start.column)
    let selectionEndIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.end.column)
    let propertyName = String(lineContainingSelection[selectionStartIndex..<selectionEndIndex])
    
    // "someObject.propertyName = somePropertyValue" -> "someObject"
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

    // "someObject.propertyName = somePropertyValue" -> "somePropertyValue"
    guard lineContainingSelection.contains(where: { $0 == "=" }),
        let propertyValue = lineContainingSelection.components(separatedBy: "=").last?.trimmingCharacters(in: .whitespacesAndNewlines) else {
        throw EnhanceObjectError.unableToFindPropertyValue
    }
    
    let propertyDefinition = inferPropertyDefinition(from: propertyValue, propertyName: propertyName)
   
    let possibleObjectDefinitions = ["struct \(typeName)", "class \(typeName)"]

    guard let objectDefinitionLineIndex = allText.firstIndex(where: { line in
        possibleObjectDefinitions.contains { line.contains($0) }
    }),
    let objectType = ["struct", "class"].first(where: { allText[objectDefinitionLineIndex].contains("\($0) ") }) else {
        throw EnhanceObjectError.unableToFindObjectDefinition
    }
    
    // Example: "struct SomeObject { }"
    let allTextOnStructDefinitionLine = allText[objectDefinitionLineIndex]
    let objectIsDefinedOnOneLineOnly = allTextOnStructDefinitionLine.contains(where: { $0 == "{"}) && allTextOnStructDefinitionLine.contains(where: { $0 == "}"})
    let indentation = String(repeating: " ", count: tabWidth)

    if objectIsDefinedOnOneLineOnly {
        updatedText[objectDefinitionLineIndex] = "\(objectType) \(typeName) {\n"
        updatedText.insert("\(indentation)\(propertyDefinition)\n", at: objectDefinitionLineIndex + 1)
        updatedText.insert("}\n", at: objectDefinitionLineIndex + 2)
    } else {
        var lastPropertyIndex: Int?

        // Iterate through lines after the object definition to find properties
        for i in (objectDefinitionLineIndex + 1)..<allText.count {
            let line = allText[i]
            
            // Stop when encountering a closing brace
            if line.contains("}") {
                break
            }
            
            // Update lastPropertyIndex if the line contains "let" or "var"
            if line.contains("let ") || line.contains("var ") {
                lastPropertyIndex = i
            }
        }

        // Insert the new property definition if a valid property index is found
        if let lastPropertyIndex = lastPropertyIndex {
            updatedText.insert("\(indentation)\(propertyDefinition)\n", at: lastPropertyIndex + 1)
        }
    }
    
    return updatedText
}

private func inferPropertyDefinition(from value: String, propertyName: String) -> String {
    let propertyType = inferPropertyType(from: value)
    return "let \(propertyName): \(propertyType)"
}

func inferPropertyType(from value: String) -> String {
    if Int(value) != nil {
        return "Int"
    } else if Double(value) != nil {
        return "Double"
    } else if value == "true" || value == "false" {
        return "Bool"
    } else if value.hasPrefix("\"") && value.hasSuffix("\"") {
        return "String"
    } else {
        return "\u{003C}#Type#\u{003E}"
    }
}

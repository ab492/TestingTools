import Foundation
import XcodeKit

func createClass(allText: [String], selectedText: [XCSourceTextRange]) throws -> String? {
    let numberOfSelectedItems = selectedText.count
    guard numberOfSelectedItems == 1,
          let selectedText = selectedText.first else {
        throw TestingToolsError.multipleSelectionNotSupported
    }
    
    let selectionIsMultiline = selectedText.start.line != selectedText.end.line
    guard selectionIsMultiline == false else {
        throw TestingToolsError.multilineSelectionNotSupported
    }

    guard let lineContainingSelection = allText[safe: selectedText.start.line] else { return nil }
    let selectionStartIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.start.column)
    let selectionEndIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.end.column)
    let selectedString = String(lineContainingSelection[selectionStartIndex..<selectionEndIndex])
    
    // Check for parentheses to identify a call without parameters
    if selectedString.hasSuffix("()") {
        let structName = String(selectedString.dropLast(2)) // Remove `()` from the end
        return "class \(structName) { }"
    }
    
    // Check if the selected string contains parameters
    let hasParameters = selectedString.contains("(") && selectedString.contains(":")
    if hasParameters {
        guard let rangeOfOpeningBracket = selectedString.range(of: "("),
              let rangeOfClosingBracket = selectedString.range(of: ")") else {
            throw TestingToolsError.invalidSelection
        }
        let structName = String(selectedString[..<rangeOfOpeningBracket.lowerBound])
        
        let allParametersString = String(selectedString[rangeOfOpeningBracket.upperBound..<rangeOfClosingBracket.lowerBound])
        let allParametersInArray = allParametersString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        var properties: [(name: String, type: String)] = []
        
        for parameter in allParametersInArray {
            let components = parameter.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
            guard components.count == 2 else { return nil }
            let propertyName = components[0]
            let propertyValue = components[1]
            
            let propertyType: String
            if propertyValue.hasPrefix("\"") && propertyValue.hasSuffix("\"") {
                propertyType = "String"
            } else if Int(propertyValue) != nil {
                propertyType = "Int"
            } else if Double(propertyValue) != nil {
                propertyType = "Double"
            } else if propertyValue == "true" || propertyValue == "false" {
                propertyType = "Bool"
            } else {
                propertyType = "\u{003C}#Type#\u{003E}"
            }
            properties.append((name: propertyName, type: propertyType))
        }
        
        let parametersString = properties.map { "\($0.name): \($0.type)" }.joined(separator: ", ")
        let assignments = properties.map { "        self.\($0.name) = \($0.name)" }.joined(separator: "\n")
        
        let classDefinition = """
        class \(structName) {
        \(properties.map { "    let \($0.name): \($0.type)" }.joined(separator: "\n"))
        
            init(\(parametersString)) {
        \(assignments)
            }
        }
        """
        
        return classDefinition
    } else {
        return "class \(selectedString) { }"
    }
}

func createStruct(allText: [String], selectedText: [XCSourceTextRange]) throws -> String? {
    let numberOfSelectedItems = selectedText.count
    guard numberOfSelectedItems == 1,
          let selectedText = selectedText.first else {
        throw TestingToolsError.multipleSelectionNotSupported
    }
    
    let selectionIsMultiline = selectedText.start.line != selectedText.end.line
    guard selectionIsMultiline == false else {
        throw TestingToolsError.multilineSelectionNotSupported
    }

    guard let lineContainingSelection = allText[safe: selectedText.start.line] else { return nil }
    let selectionStartIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.start.column)
    let selectionEndIndex = lineContainingSelection.index(lineContainingSelection.startIndex, offsetBy: selectedText.end.column)
    let selectedString = String(lineContainingSelection[selectionStartIndex..<selectionEndIndex])

    // Check for parentheses to identify a call without parameters
    if selectedString.hasSuffix("()") {
        let structName = String(selectedString.dropLast(2)) // Remove `()` from the end
        return "struct \(structName) { }"
    }

    // Check if the selected string contains parameters
    let hasParameters = selectedString.contains(":")
    if hasParameters {
        guard let rangeOfOpeningBracket = selectedString.range(of: "("),
              let rangeOfClosingBracket = selectedString.range(of: ")") else {
            throw TestingToolsError.invalidSelection
        }
        let structName = String(selectedString[..<rangeOfOpeningBracket.lowerBound])
        
        let allParametersString = String(selectedString[rangeOfOpeningBracket.upperBound..<rangeOfClosingBracket.lowerBound])
        let allParametersInArray = allParametersString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        var properties: [(name: String, type: String)] = []
        
        for parameter in allParametersInArray {
            let components = parameter.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
            guard components.count == 2 else { return nil }
            let propertyName = components[0]
            let propertyValue = components[1]
            
            let propertyType: String
            if propertyValue.hasPrefix("\"") && propertyValue.hasSuffix("\"") {
                propertyType = "String"
            } else if Int(propertyValue) != nil {
                propertyType = "Int"
            } else if Double(propertyValue) != nil {
                propertyType = "Double"
            } else if propertyValue == "true" || propertyValue == "false" {
                propertyType = "Bool"
            } else {
                propertyType = "\u{003C}#Type#\u{003E}"
            }
            
            properties.append((name: propertyName, type: propertyType))
        }
        
        let structDefinition = """
        struct \(structName) {
        \(properties.map { "    let \($0.name): \($0.type)" }.joined(separator: "\n"))
        }
        """
        
        return structDefinition
    } else {
        return "struct \(selectedString) { }"
    }
}

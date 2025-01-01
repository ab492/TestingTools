import Foundation
import XcodeKit

enum ObjectType: String {
    case `struct`
    case `class`
}

func createObject(_ type: ObjectType, allText: [String], selectedText: [XCSourceTextRange], tabWidth: Int) throws -> [String]? {
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
    
    let hasParameters = selectedString.contains("(") && selectedString.contains(":")
    if hasParameters {
        guard let rangeOfOpeningBracket = selectedString.range(of: "("),
              let rangeOfClosingBracket = selectedString.range(of: ")") else {
            throw TestingToolsError.invalidSelection
        }
        
        let objectName = String(selectedString[..<rangeOfOpeningBracket.lowerBound])
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
        
        var classDefinition: [String] = []
        classDefinition.append("\(type.rawValue) \(objectName) {\n")
         
         // Add properties
         for property in properties {
             let indentation = String(repeating: " ", count: tabWidth)
             classDefinition.append("\(indentation)let \(property.name): \(property.type)\n")
         }
         
        let addInitialiser = type == .class
        if addInitialiser {
            classDefinition.append("\n")
            let initIndentation = String(repeating: " ", count: tabWidth)
            classDefinition.append("\(initIndentation)init(\(properties.map { "\($0.name): \($0.type)" }.joined(separator: ", "))) {\n")
            for property in properties {
                classDefinition.append("\(initIndentation)\(initIndentation)self.\(property.name) = \(property.name)\n")
            }
            classDefinition.append("\(initIndentation)}\n")
        }
        classDefinition.append("}\n")

         
         var updatedText = allText
         updatedText.append("\n")
         updatedText.append(contentsOf: classDefinition)
         return updatedText
    } else {
        let className: String
        if selectedString.hasSuffix("()") {
            className = String(selectedString.dropLast(2)) // Remove `()` from the end
        } else {
            className = selectedString
        }
        
        var updatedText = allText
        updatedText.append("\n")
        let newText = ["\(type.rawValue) \(className) { }\n"]
        updatedText.append(contentsOf: newText)
        return updatedText
    }
}

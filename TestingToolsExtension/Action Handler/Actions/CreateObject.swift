import Foundation
import XcodeKit

enum ObjectType: String {
    case `struct`
    case `class`
}

func createObject(
    _ type: ObjectType,
    allText: [String],
    selectedText: XCSourceTextRange,
    lineContainingSelection: String,
    tabWidth: Int
) throws -> [String] {

    var updatedText = allText
    updatedText.append("\n")

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
        let indentation = String(repeating: " ", count: tabWidth)
        let allParametersString = String(selectedString[rangeOfOpeningBracket.upperBound..<rangeOfClosingBracket.lowerBound])
        let allParametersInArray = allParametersString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        var properties: [(name: String, type: String)] = []
        
        for parameter in allParametersInArray {
            let components = parameter.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
            guard components.count == 2 else { throw TestingToolsError.invalidSelection }
            let propertyName = components[0]
            let propertyValue = components[1]
            let propertyType = inferPropertyType(from: propertyValue)
            properties.append((name: propertyName, type: propertyType))
        }
        
        var objectDefinition: [String] = []
        objectDefinition.append("\(type.rawValue) \(objectName) {\n") // E.g. class MyClass {
         
         for property in properties {
             objectDefinition.append("\(indentation)let \(property.name): \(property.type)\n") // E.g. let string: String
         }
         
        let shouldAddInit = type == .class
        if shouldAddInit {
            objectDefinition.append("\n")
            objectDefinition.append("\(indentation)init(\(properties.map { "\($0.name): \($0.type)" }.joined(separator: ", "))) {\n")
            for property in properties {
                objectDefinition.append("\(indentation)\(indentation)self.\(property.name) = \(property.name)\n")
            }
            objectDefinition.append("\(indentation)}\n")
        }
        objectDefinition.append("}\n")
        
        updatedText.append(contentsOf: objectDefinition)
        
    } else {

        let objectName: String
        if selectedString.hasSuffix("()") {
            objectName = String(selectedString.dropLast(2)) // Remove `()` from the end
        } else {
            objectName = selectedString
        }
        
        let objectDefinition = ["\(type.rawValue) \(objectName) { }\n"]
        
        updatedText.append(contentsOf: objectDefinition)
    }
    return updatedText
}

//
//  TestingToolsError.swift
//  TestingTools
//
//  Created by Andy Brown on 29/11/2024.
//
import Foundation
import XcodeKit

enum TestingToolsError: Error, LocalizedError, CustomNSError {
    case multipleSelectionNotSupported
    case multilineSelectionNotSupported
    
    var localizedDescription: String {
        switch self {
        case .multipleSelectionNotSupported:
            return "Multiple text selections are not supported"
        case .multilineSelectionNotSupported:
            return "Multiline text selections are not supported"
        }
    }
    
    var errorUserInfo: [String: Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

func createStruct(allText: [String], selectedText: [XCSourceTextRange]) throws -> String? {
    let numberOfSelectedItems = selectedText.count
    
    guard numberOfSelectedItems == 1 else {
        throw TestingToolsError.multipleSelectionNotSupported
    }
    
    let selectedText = selectedText.first!
    
    let selectionIsMultiline = selectedText.start.line != selectedText.end.line
    if selectionIsMultiline {
        throw TestingToolsError.multilineSelectionNotSupported
    }
        
    guard let line = allText[safe: selectedText.start.line] else { return nil }
    

    
    let startIndex = line.index(line.startIndex, offsetBy: selectedText.start.column)
    let endIndex = line.index(line.startIndex, offsetBy: selectedText.end.column)
    let selectedWord = String(line[startIndex..<endIndex])
    

    if selectedWord.contains(":") { // We're dealing with parameters
        // Extract the struct name
        guard let structNameStartIndex = line.range(of: "let sut = ")?.upperBound,
              let structNameEndIndex = line[structNameStartIndex...].range(of: "(")?.lowerBound else {
            return nil
        }
        let structName = String(line[structNameStartIndex..<structNameEndIndex])

        // Extract parameters and their types
        let parametersStartIndex = line.range(of: "(")?.upperBound
        let parametersEndIndex = line.range(of: ")")?.lowerBound
        guard let parametersRange = parametersStartIndex.flatMap({ start in
            parametersEndIndex.map { end in
                start..<end
            }
        }) else {
            return nil
        }
        let parametersString = line[parametersRange]
        let parameters = parametersString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        // Generate properties with inferred types
        let properties = parameters.compactMap { parameter -> String? in
            let parts = parameter.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
            guard parts.count == 2 else { return nil }
            let propertyName = parts[0]
            let propertyValue = parts[1]

            // Infer type based on the value
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
                propertyType = "Unknown"
            }

            return "    let \(propertyName): \(propertyType)"
        }

        // Construct the struct
        let structDefinition = """
        struct \(structName) {
        \(properties.joined(separator: "\n"))
        }
        """
        return structDefinition
    }

    
    return "struct \(selectedWord) { }"
}

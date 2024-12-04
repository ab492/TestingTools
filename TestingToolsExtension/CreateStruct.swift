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

    let hasParameters = selectedString.contains(":")
    if hasParameters {
        guard let rangeOfOpeningBracket = selectedString.range(of: "("),
              let rangeOfClosingBracket = selectedString.range(of: ")") else { return nil } // TODO: Test an error thrown here!
        let structName = String(selectedString[..<rangeOfOpeningBracket.lowerBound])
        
        let allParametersString = String(selectedString[rangeOfOpeningBracket.upperBound..<rangeOfClosingBracket.lowerBound])
        let allParametersInArray = allParametersString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        let firstProperty = allParametersInArray.first!.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
        guard firstProperty.count == 2 else { return nil }
        let propertyName = firstProperty[0]
        let propertyValue = firstProperty[1]
        
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
            return nil
        }
        
        let structDefinition = """
        struct \(structName) {
            let \(propertyName): \(propertyType)
        }
        """

        return structDefinition
    } else {
        return "struct \(selectedString) { }"
    }
}

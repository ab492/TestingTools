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
    
    
    let hasParameters = selectedWord.contains(":")
    if hasParameters {
        guard let rangeOfOpeningBracket = selectedWord.range(of: "("),
              let rangeOfClosingBracket = selectedWord.range(of: ")") else { return nil } // TODO: Test an error thrown here!
        let structName = String(selectedWord[..<rangeOfOpeningBracket.lowerBound])
        
        let allParametersString = String(selectedWord[rangeOfOpeningBracket.upperBound..<rangeOfClosingBracket.lowerBound])
        let allParametersInArray = allParametersString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        let firstProperty = allParametersInArray.first!.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
        guard firstProperty.count == 2 else { return nil }
        let propertyName = firstProperty[0]
        let propertyValue = firstProperty[1]
        
        let propertyType: String
        if propertyValue.hasPrefix("\"") && propertyValue.hasSuffix("\"") {
            propertyType = "String"
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
        return "struct \(selectedWord) { }"
    }
}

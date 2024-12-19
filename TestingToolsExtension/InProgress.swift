//
//  InProgress.swift
//  Testing Tools Host
//
//  Created by Andy Brown on 17/12/2024.
//

import Foundation
import XcodeKit

func addProgressMarker(allText: [String], selectedText: [XCSourceTextRange]) -> [String] {
    var updatedText = allText
    
    for range in selectedText {
        let startLine = range.start.line
        let endLine = range.end.line
        
        for lineIndex in startLine...endLine {
            let trimmedLine = updatedText[lineIndex].trimmingCharacters(in: .newlines)
            updatedText[lineIndex] = "\(trimmedLine) ⬅️\n"
        }
    }
    return updatedText
}

//
//  InProgress.swift
//  Testing Tools Host
//
//  Created by Andy Brown on 17/12/2024.
//

import Foundation
import XcodeKit

func markInProgress(allText: [String], selectedText: [XCSourceTextRange]) -> [String] {
    var updatedText = allText
    
    for range in selectedText {
        let startLine = range.start.line
        let endLine = range.end.line
        
        for lineIndex in startLine...endLine {
            updatedText[lineIndex] += " ⬅️"
        }
    }
    return updatedText
}

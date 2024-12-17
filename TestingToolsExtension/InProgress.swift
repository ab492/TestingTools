//
//  InProgress.swift
//  Testing Tools Host
//
//  Created by Andy Brown on 17/12/2024.
//

import Foundation
import XcodeKit

func markInProgress(allText: [String], selectedText: XCSourceTextRange) -> [String] {
    var updatedText = allText
    let startLine = selectedText.start.line
    let endLine = selectedText.end.line
    
    for lineIndex in startLine...endLine {
        let line = updatedText[lineIndex]
        updatedText[lineIndex] = line + " ⬅️"
    }
    return updatedText
}


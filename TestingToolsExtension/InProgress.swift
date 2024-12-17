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
    let lineIndex = selectedText.start.line
    
    let line = updatedText[lineIndex]
    updatedText[lineIndex] = line + " ⬅️"
    
        // Ensure the selected range points to a valid line in the text
//        let startLine = selectedText.start.line
//        let endLine = selectedText.end.line
//        
//        for lineIndex in startLine...endLine {
//            // Safely update the line only if it exists
//            if lineIndex < updatedText.count {
//                let line = updatedText[lineIndex].trimmingCharacters(in: .whitespacesAndNewlines)
//                
//                // Add the arrow only if it hasn't been added already
//                if !line.hasSuffix("⬅️") {
//                    updatedText[lineIndex] = line + " ⬅️"
//                }
//            }
//        }
//        
        return updatedText
    }


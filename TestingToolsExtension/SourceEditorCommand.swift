//
//  SourceEditorCommand.swift
//  TestingToolsExtension
//
//  Created by Andy Brown on 23/11/2024.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        let buffer = invocation.buffer
        let selections = buffer.selections as! [XCSourceTextRange]
        
        var selectedText = ""
        
        for selection in selections {
            let startLine = selection.start.line
            let startColumn = selection.start.column
            let endLine = selection.end.line
            let endColumn = selection.end.column
            
            
            // Handle single-line and multi-line selections
            if startLine == endLine {
                // Single-line selection
                if let line = buffer.lines[startLine] as? String {
                    let range = line.index(line.startIndex, offsetBy: startColumn)..<line.index(line.startIndex, offsetBy: endColumn)
                    selectedText += String(line[range])
                }
            }
        }
        
        print("SELECTED TEXT: \(selectedText)")

        
        
        //
        let lines = invocation.buffer.lines
        let stringLines = lines as! [String]
        let createType = CreateType()
        let newLines = createType.createStruct(from: "")
        newLines.forEach {
            lines.add($0)
        }
        
        completionHandler(nil)
    }
    
}

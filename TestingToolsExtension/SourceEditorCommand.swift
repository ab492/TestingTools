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
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        let lines = invocation.buffer.lines
        let stringLines = lines as! [String]
        let createType = CreateType()
        let newLines = createType.createStruct(from selection: stringLines)
        
        newLines.forEach {
            lines.add($0)
        }
        
        completionHandler(nil)
    }
    
}

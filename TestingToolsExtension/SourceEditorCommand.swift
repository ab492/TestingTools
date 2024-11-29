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
        let allLines = buffer.lines as! [String]
        
        do {
            if let maybeNewStruct = try createStruct(allText: allLines, selectedText: selections) {
                buffer.lines.add(maybeNewStruct)
                completionHandler(nil)
            }
        } catch {
            completionHandler(error)
        }
    }
}

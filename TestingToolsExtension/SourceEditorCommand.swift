//
//  SourceEditorCommand.swift
//  TestingToolsExtension
//
//  Created by Andy Brown on 23/11/2024.
//

import Foundation
import XcodeKit

enum Action: String, CaseIterable {
    case createStruct = "testingtools.createStruct"
    case createClass = "testingtools.createClass"
    
    var identifier: String {
        self.rawValue
    }
    
    var name: String {
        switch self {
        case .createStruct: return "Create Struct"
        case .createClass: return "Create Class"
        }
    }
}

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        guard let action = Action(rawValue: invocation.commandIdentifier) else {
            return completionHandler(nil)
        }
        
        let buffer = invocation.buffer
        let selections = buffer.selections as! [XCSourceTextRange]
        let allLines = buffer.lines as! [String]
        
        do {
            let textToAdd: String?
            
            switch action {
            case .createStruct: textToAdd = try createStruct(allText: allLines, selectedText: selections)
            case .createClass: textToAdd = try createClass(allText: allLines, selectedText: selections)
            }
            
            if let textToAdd {
                buffer.lines.add(textToAdd)
                completionHandler(nil)
            }
        } catch {
            completionHandler(error)
        }
    }
}


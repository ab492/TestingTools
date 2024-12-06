//
//  SourceEditorExtension.swift
//  TestingToolsExtension
//
//  Created by Andy Brown on 23/11/2024.
//

import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    /*
    func extensionDidFinishLaunching() {
        // If your extension needs to do any work at launch, implement this optional method.
    }
    */
    
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        return Action.allCases
            .map { [XCSourceEditorCommandDefinitionKey.identifierKey: $0.identifier,
                    XCSourceEditorCommandDefinitionKey.nameKey: $0.name,
                    XCSourceEditorCommandDefinitionKey.classNameKey: SourceEditorCommand.className()
                ]}
    }
    
}

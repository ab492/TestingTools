import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        return Action.allCases
            .map { [
                XCSourceEditorCommandDefinitionKey.identifierKey: $0.identifier,
                XCSourceEditorCommandDefinitionKey.nameKey: $0.name,
                XCSourceEditorCommandDefinitionKey.classNameKey: SourceEditorCommand.className()
            ]}
    }
}

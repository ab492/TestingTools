import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        guard let action = Action(rawValue: invocation.commandIdentifier) else {
            return completionHandler(nil)
        }
        
        let buffer = invocation.buffer
        let selections = buffer.selections as! [XCSourceTextRange]
        let allLines = buffer.lines as! [String]
        
        do {
            let textToAdd = try CommandActionHandler.handle(
                action: action,
                allText: allLines,
                selections: selections,
                tabWidth: buffer.tabWidth
            )
            buffer.lines.removeAllObjects()
            buffer.lines.addObjects(from: textToAdd)
            completionHandler(nil)
        } catch {
            completionHandler(error)
        }
    }
}

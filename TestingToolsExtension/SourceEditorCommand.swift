import Foundation
import XcodeKit

enum Action: String, CaseIterable {
    case createStruct
    case createClass
    case createLocalProperty
    case createGlobalProperty
    case markInProgress
    case markAsDone
    
    
    var rawValue: String {
        return "testingtools.\(self)" // E.g. "testingtools.createStruct"
    }
    
    var identifier: String {
        self.rawValue
    }
    
    var name: String {
        switch self {
        case .createStruct: return "Create Struct"
        case .createClass: return "Create Class"
        case .createLocalProperty: return "Create Local Property"
        case .createGlobalProperty: return "Create Global Property"
        case .markInProgress: return "Mark in Progress ⬅️"
        case .markAsDone: return "Mark as Done ✅"
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

import Foundation
import XcodeKit

enum Action: String, CaseIterable {
    case createStruct = "testingtools.createStruct"
    case createClass = "testingtools.createClass"
    case createLocalProperty = "testingtools.createLocalProperty"
    case markInProgress = "testingtools.markInProgress"
    case markAsDone = "testingtools.markAsDone"
    
    var identifier: String {
        self.rawValue
    }
    
    var name: String {
        switch self {
        case .createStruct: return "Create Struct"
        case .createClass: return "Create Class"
        case .createLocalProperty: return "Create Local Property"
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
            switch action {
            case .createStruct:
                let textToAdd = try createObject(.struct, allText: allLines, selectedText: selections, tabWidth: buffer.tabWidth)
                if let textToAdd {
                    buffer.lines.removeAllObjects()
                    buffer.lines.addObjects(from: textToAdd)
                    completionHandler(nil)
                }
            case .createClass:
                let textToAdd = try createObject(.class, allText: allLines, selectedText: selections, tabWidth: buffer.tabWidth)
                if let textToAdd {
                    buffer.lines.removeAllObjects()
                    buffer.lines.addObjects(from: textToAdd)
                    completionHandler(nil)
                }
            case .markInProgress:
                let updatedText = addProgressMarker(.inProgress, allText: allLines, selectedText: selections)
                 buffer.lines.removeAllObjects()
                 buffer.lines.addObjects(from: updatedText)
                 completionHandler(nil)
            
            case .markAsDone:
                let updatedText = addProgressMarker(.done, allText: allLines, selectedText: selections)
                 buffer.lines.removeAllObjects()
                 buffer.lines.addObjects(from: updatedText)
                 completionHandler(nil)
                
            case .createLocalProperty:
                let updatedText = try CommandActionHandler.handle(
                    action: .createLocalProperty,
                    allText: allLines,
                    selections: selections,
                    tabWidth: buffer.tabWidth
                )
                buffer.lines.removeAllObjects()
                buffer.lines.addObjects(from: updatedText)
                completionHandler(nil)
            }

        } catch {
            completionHandler(error)
        }
    }
}

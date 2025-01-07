import Foundation
import XcodeKit

struct CommandActionHandler {
    static func handle(
        action: Action,
        allText: [String],
        selections: [XCSourceTextRange],
        tabWidth: Int = 4
    ) throws -> [String] {
        switch action {
            
        case .createClass:
            return try createObject(
                .class,
                allText: allText,
                selectedText: selections,
                tabWidth: tabWidth
            )
            
        case .createStruct:
            return try createObject(
                .struct,
                allText: allText,
                selectedText: selections,
                tabWidth: tabWidth
            )
            
        case .createLocalProperty:
            return try createProperty(
                allText: allText,
                selectedText: selections
            )
            
        case .createGlobalProperty:
            return try createGlobalProperty(
                allText: allText,
                selectedText: selections
            )
            
        case .markAsDone:
            return addProgressMarker(
                .done,
                allText: allText,
                selectedText: selections
            )
            
        case .markInProgress:
            return addProgressMarker(
                .inProgress,
                allText: allText,
                selectedText: selections
            )
        }
    }
}

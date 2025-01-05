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
        case .createLocalProperty:
            return try createProperty(allText: allText, selectedText: selections)
        case .markAsDone:
            return addProgressMarker(.done, allText: allText, selectedText: selections)
        case .markInProgress:
            return addProgressMarker(.inProgress, allText: allText, selectedText: selections)
        default: return []
        }
    }
}

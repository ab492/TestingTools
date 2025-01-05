import Foundation
import XcodeKit

struct CommandActionHandler {
    static func handle(
        action: Action,
        allText: [String],
        selections: [XCSourceTextRange],
        tabWidth: Int
    ) throws -> [String] {
        switch action {
        case .createLocalProperty:
            return try createProperty(allText: allText, selectedText: selections)
        default: return []
        }
    }
}

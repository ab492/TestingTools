import Foundation
import XcodeKit

struct CommandActionHandler {
    static func handle(
        action: Action,
        allText: [String],
        selections: [XCSourceTextRange],
        tabWidth: Int
    ) throws -> [String] {
        
        if selections.count > 1, action.isProgressMarker == false {
            throw TestingToolsError.multipleSelectionNotSupported
        }
        
        guard let selectedText = selections.first else {
            throw TestingToolsError.invalidSelection
        }
        
        guard selectedText.start.line == selectedText.end.line else {
            throw TestingToolsError.multilineSelectionNotSupported
        }
        
        guard let lineContainingSelection = allText[safe: selectedText.start.line] else {
            throw TestingToolsError.invalidSelection
        }
        
        switch action {
            
        case .createClass:
            return try createObject(
                .class,
                allText: allText,
                selectedText: selectedText,
                lineContainingSelection: lineContainingSelection,
                tabWidth: tabWidth
            )
            
        case .createStruct:
            return try createObject(
                .struct,
                allText: allText,
                selectedText: selectedText,
                lineContainingSelection: lineContainingSelection,
                tabWidth: tabWidth
            )
            
        case .createInstanceProperty:
            return try createProperty(
                type: .instance,
                allText: allText,
                selectedText: selectedText,
                lineContainingSelection: lineContainingSelection,
                tabWidth: tabWidth
            )
        case .createLocalProperty:
            return try createProperty(
                type: .local,
                allText: allText,
                selectedText: selectedText,
                lineContainingSelection: lineContainingSelection,
                tabWidth: tabWidth
            )
            
        case .createGlobalProperty:
            return try createProperty(
                type: .global,
                allText: allText,
                selectedText: selectedText,
                lineContainingSelection: lineContainingSelection,
                tabWidth: tabWidth
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
            
        case .addPropertyToObject:
            return try enhanceObject(
                type: .addInstanceProperty,
                allText: allText,
                selectedText: selectedText,
                lineContainingSelection: lineContainingSelection,
                tabWidth: tabWidth
            )
            
        case .addMethodToObject:
            return try enhanceObject(
                type: .addInstanceMethod,
                allText: allText,
                selectedText: selectedText,
                lineContainingSelection: lineContainingSelection,
                tabWidth: tabWidth
            )
        }
        
    }
}

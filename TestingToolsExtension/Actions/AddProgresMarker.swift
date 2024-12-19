import Foundation
import XcodeKit

enum ProgressMarker {
    case inProgress
    case done
    
    var icon: String {
        switch self {
        case .inProgress: return "⬅️"
        case .done: return "✅"
        }
    }
}

func addProgressMarker(_ progressMarker: ProgressMarker, allText: [String], selectedText: [XCSourceTextRange]) -> [String] {
    var updatedText = allText
    
    for range in selectedText {
        let startLine = range.start.line
        let endLine = range.end.line
        
        for lineIndex in startLine...endLine {
            let trimmedLine = updatedText[lineIndex].trimmingCharacters(in: .newlines)
            updatedText[lineIndex] = "\(trimmedLine) \(progressMarker.icon)\n"
        }
    }
    return updatedText
}

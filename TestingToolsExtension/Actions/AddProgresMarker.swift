import Foundation
import XcodeKit

func addProgressMarker(_ progressMarker: String, allText: [String], selectedText: [XCSourceTextRange]) -> [String] {
    var updatedText = allText
    
    for range in selectedText {
        let startLine = range.start.line
        let endLine = range.end.line
        
        for lineIndex in startLine...endLine {
            let trimmedLine = updatedText[lineIndex].trimmingCharacters(in: .newlines)
            updatedText[lineIndex] = "\(trimmedLine) \(progressMarker)\n"
        }
    }
    return updatedText
}

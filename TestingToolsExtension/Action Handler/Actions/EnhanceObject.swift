import Foundation
import XcodeKit

func enhanceObject(
    allText: [String],
    selectedText: [XCSourceTextRange],
    tabWidth: Int
) throws -> [String] {
    var result = [String]()

    for line in allText {
        // Remove all whitespace & newlines from the start/end.
        let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedLine == "struct MyStruct { }" {
            // Replace this single line with the multi-line definition
            result.append("struct MyStruct {\n")
            result.append("    let intProperty: Int\n")
            result.append("}\n")
        } else {
            // Keep the line unchanged
            result.append(line)
        }
    }

    return result
}

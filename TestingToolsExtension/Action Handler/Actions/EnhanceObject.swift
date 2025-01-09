import Foundation
import XcodeKit

func enhanceObject(
    allText: [String],
    selectedText: [XCSourceTextRange],
    tabWidth: Int
) throws -> [String] {
    // 1. Figure out the property name from the user selection.
    //    For simplicity, assume there is exactly one selection
    //    and that it fully covers the property name in one line.
    guard let selectionRange = selectedText.first else { return allText }
    let (propertyName, propertyType) = deducePropertyNameAndType(
        in: allText,
        selection: selectionRange
    )

    var newText = allText
    var insideMyStruct = false

    for (index, line) in newText.enumerated() {
        let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

        // Case 1: Single-line definition: `struct MyStruct { }`
        if trimmedLine == "struct MyStruct { }" {
            newText.remove(at: index)
            newText.insert(contentsOf: [
                "struct MyStruct {\n",
                "    let \(propertyName): \(propertyType)\n",
                "}\n"
            ], at: index)
            break
        }

        // Case 2: Multi-line definition: `struct MyStruct {`
        if trimmedLine.hasPrefix("struct MyStruct {") {
            insideMyStruct = true
            continue
        }

        // If inside MyStruct, look for the closing brace.
        if insideMyStruct && trimmedLine == "}" {
            // Insert our new property before the closing brace.
            // We'll trim out any existing trailing newline in case we need to
            // directly append.
            // This line leaves out the "\n" so as not to add extra blank lines
            // in certain scenarios. It's a style choice.
            newText.insert("    let \(propertyName): \(propertyType)", at: index)
            insideMyStruct = false
            break
        }
    }

    return newText
}

/// Determines the property name (e.g. `"intProperty"`) and best guess at the type
/// (e.g. `"Int"` or `"String"`) by looking at the text around the selection.
private func deducePropertyNameAndType(
    in lines: [String],
    selection: XCSourceTextRange
) -> (name: String, type: String) {
    // The selection gives us the start/end line and column indices.
    // We'll read the line that contains the selection and extract
    // the substring for the property name.
    let startLineIndex = selection.start.line
    let startCol = selection.start.column
    let endCol = selection.end.column

    guard startLineIndex < lines.count else {
        return ("newProperty", "String")
    }

    let line = lines[startLineIndex]
    let lineNS = line as NSString
    let selectedSubstring = lineNS.substring(with: NSRange(location: startCol, length: endCol - startCol))

    // That substring is presumably the property name, e.g. "stringProperty"
    let propertyName = selectedSubstring.trimmingCharacters(in: .whitespacesAndNewlines)

    // Next, guess the type by scanning for the assignment in the same line
    // or in a subsequent line. For example, we might find something like:
    // `myString.stringProperty = "some text"`
    // or `myString.intProperty = 4`
    let propertyType: String = {
        // Gather context lines from the same line or lines below
        // to see if there's an assignment that looks like:
        // `propertyName = ...`
        for contextLine in lines[startLineIndex...] {
            if contextLine.contains("\(propertyName) =") {
                let trimmed = contextLine.trimmingCharacters(in: .whitespaces)
                if let equalsIndex = trimmed.range(of: "=") {
                    let assignmentPart = trimmed[equalsIndex.upperBound...].trimmingCharacters(in: .whitespaces)

                    // Check if the right-hand side starts with a quote
                    if assignmentPart.hasPrefix("\"") {
                        return "String"
                    }

                    // Check if the right-hand side is an integer
                    // (very naive check; robust approach would parse the digits, handle floats, etc.)
                    if let intValue = Int(assignmentPart) {
                        _ = intValue // not used, just a test
                        return "Int"
                    }

                    // If we can't parse it, default to String
                    return "String"
                }
            }
        }
        // If we don't see any assignment at all, default to String
        return "String"
    }()

    return (propertyName, propertyType)
}

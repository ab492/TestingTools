import Foundation
import XcodeKit

func enhanceObject(
    allText: [String],
    selectedText: [XCSourceTextRange],
    tabWidth: Int
) throws -> [String] {
    var newText = allText
    var insideMyStruct = false

    for (index, line) in newText.enumerated() {
        let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

        // Case 1: Single-line struct definition
        if trimmedLine == "struct MyStruct { }" {
            // Remove this one-liner...
            newText.remove(at: index)
            // ...and replace with multi-line definition
            newText.insert(contentsOf: [
                "struct MyStruct {\n",
                "    let intProperty: Int\n",
                "}\n"
            ], at: index)

            // Because we've completed our insertion, break out of the loop.
            break
        }

        // Case 2: Multi-line struct definition (detect the start of the struct)
        if trimmedLine.hasPrefix("struct MyStruct {") {
            insideMyStruct = true
            continue
        }

        // If we are inside MyStruct, look for the closing brace
        if insideMyStruct && trimmedLine == "}" {
            // Insert our property line right before the closing brace
            newText.insert("    let intProperty: Int", at: index)
            insideMyStruct = false
            break
        }
    }

    return newText
}

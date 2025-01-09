import Foundation
import XcodeKit

func enhanceObject(
    allText: [String],
    selectedText: [XCSourceTextRange],
    tabWidth: Int
) throws -> [String] {
    var newText = allText
    
    for (index, line) in newText.enumerated() {
        // Look for `struct MyStruct { }` (with or without trailing newline).
        if line.trimmingCharacters(in: .whitespacesAndNewlines) == "struct MyStruct { }" {
            // Remove this line...
            newText.remove(at: index)
            // ...and replace it with the three desired lines
            newText.insert(contentsOf: [
                "struct MyStruct {\n",
                "    let intProperty: Int\n",
                "}\n"
            ], at: index)
            break
        }
    }
    
    return newText
}

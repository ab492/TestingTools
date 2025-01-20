import Foundation

let unknownTypePlaceholder = "\u{003C}#Type#\u{003E}"

func inferPropertyType(from value: String) -> String {
    if Int(value) != nil {
        return "Int"
    } else if Double(value) != nil {
        return "Double"
    } else if value == "true" || value == "false" {
        return "Bool"
    } else if value.hasPrefix("\"") && value.hasSuffix("\"") {
        return "String"
    } else {
        return unknownTypePlaceholder
    }
}

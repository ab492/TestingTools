import Foundation

enum TestingToolsError: Error, LocalizedError, CustomNSError {
    case multipleSelectionNotSupported
    case multilineSelectionNotSupported
    case invalidSelection
    case noObjectToCreateInstancePropertyOn
    case fatalError
    
    var localizedDescription: String {
        switch self {
        case .multipleSelectionNotSupported:
            return "Multiple text selections are not supported"
        case .multilineSelectionNotSupported:
            return "Multiline text selections are not supported"
        case .invalidSelection:
            return "Invalid selection"
        case .noObjectToCreateInstancePropertyOn:
            return "No object to create instance property on - is there an enclosing struct or class?"
        case .fatalError:
            return "An unexpected error occurred, please email andy@bramblytech.co.uk to log a bug."
        }
    }
    
    var errorUserInfo: [String: Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

import Foundation

enum TestingToolsError: Error, LocalizedError, CustomNSError {
    case multipleSelectionNotSupported
    case multilineSelectionNotSupported
    case invalidSelection
    case fatalError
    
    var localizedDescription: String {
        switch self {
        case .multipleSelectionNotSupported:
            return "Multiple text selections are not supported"
        case .multilineSelectionNotSupported:
            return "Multiline text selections are not supported"
        case .invalidSelection:
            return "Invalid selection"
        case .fatalError:
            return "An unexpected error occurred, please email andy@bramblytech.co.uk to log a bug."
        }
    }
    
    var errorUserInfo: [String: Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

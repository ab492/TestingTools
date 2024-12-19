import Foundation

enum TestingToolsError: Error, LocalizedError, CustomNSError {
    case multipleSelectionNotSupported
    case multilineSelectionNotSupported
    case invalidSelection
    
    var localizedDescription: String {
        switch self {
        case .multipleSelectionNotSupported:
            return "Multiple text selections are not supported"
        case .multilineSelectionNotSupported:
            return "Multiline text selections are not supported"
        case .invalidSelection:
            return "Invalid selection"
        }
    }
    
    var errorUserInfo: [String: Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

import Foundation

enum Action: String, CaseIterable {
    case createStruct = "testingtools.createStruct"
    case createClass = "testingtools.createClass"
    case createLocalProperty = "testingtools.createLocalProperty"
    case createGlobalProperty = "testingtools.createGlobalProperty"
    case markInProgress = "testingtools.markInProgress"
    case markAsDone = "testingtools.markAsDone"
    
    var identifier: String {
        self.rawValue
    }
    
    var name: String {
        switch self {
        case .createStruct: return "Create Struct"
        case .createClass: return "Create Class"
        case .createLocalProperty: return "Create Local Property"
        case .createGlobalProperty: return "Create Global Property"
        case .markInProgress: return "Mark in Progress ⬅️"
        case .markAsDone: return "Mark as Done ✅"
        }
    }
}

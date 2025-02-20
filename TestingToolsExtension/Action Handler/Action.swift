import Foundation

enum Action: String, CaseIterable {
    case createStruct = "testingtools.createStruct"
    case createClass = "testingtools.createClass"
    case createInstanceProperty = "testingtools.createInstanceProperty"
    case createLocalProperty = "testingtools.createLocalProperty"
    case createGlobalProperty = "testingtools.createGlobalProperty"
    case markInProgress = "testingtools.markInProgress"
    case markAsDone = "testingtools.markAsDone"
    case addPropertyToObject = "testingtools.addPropertyToObject"
    case addMethodToObject = "testingtools.addMethodToObject"
    
    var identifier: String {
        self.rawValue
    }
    
    var name: String {
        switch self {
        case .createStruct: return "Create Struct"
        case .createClass: return "Create Class"
        case .createInstanceProperty: return "Create Instance Property"
        case .createLocalProperty: return "Create Local Property"
        case .createGlobalProperty: return "Create Global Property"
        case .markInProgress: return "Mark in Progress ⬅️"
        case .markAsDone: return "Mark as Done ✅"
        case .addPropertyToObject: return "Add Property To Object"
        case .addMethodToObject: return "Add Method To Object"
        }
    }
    
    var isProgressMarker: Bool {
        switch self {
        case .markAsDone, .markInProgress: return true
        default: return false
        }
    }
}

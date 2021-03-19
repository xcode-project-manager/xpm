import Foundation
import ProjectDescription

public enum Module: String {
    case support
    case graph
    case projectDescription
    
    public var name: String {
        switch self {
        case .projectDescription:
            return "ProjectDescription"
        default:
            return "Tuist\(rawValue.capitalized)"
        }
    }
    public var dependency: TargetDependency {
        .target(name: self.name)
    }
    
    public var testingName: String? {
        switch self {
        case .projectDescription:
            return nil
        default:
            return "Tuist\(rawValue.capitalized)Testing"
        }
    }
    public var testingDependency: TargetDependency? {
        self.testingName.map(TargetDependency.target)
    }
    
    public var testsName: String? {
        switch self {
        case .projectDescription:
            return "ProjectDescriptionTests"
        default:
            return "Tuist\(rawValue.capitalized)Tests"
        }
    }
}

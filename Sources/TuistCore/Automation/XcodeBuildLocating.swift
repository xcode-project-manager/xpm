import Foundation
import TSCBasic
import TuistSupport

public protocol XcodeBuildLocating {
    func buildDirectory(for projectTarget: XcodeBuildTarget, configuration: String, sdk: String, developerEnvironment: DeveloperEnvironmenting) throws -> AbsolutePath
}

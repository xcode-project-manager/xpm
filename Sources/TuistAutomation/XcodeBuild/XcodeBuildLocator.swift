import TuistCore
import TSCBasic
import TuistSupport

public class XcodeBuildLocator: XcodeBuildLocating {
    public init() {}

    public func buildDirectory(for projectTarget: XcodeBuildTarget, configuration: String, sdk: String, developerEnvironment: DeveloperEnvironmenting) throws -> AbsolutePath {
        let derivedDataPath = developerEnvironment.derivedDataDirectory
        let pathString = projectTarget.path.pathString
        let hash = try XcodeProjectPathHasher.hashString(for: pathString)

        return derivedDataPath
            .appending(component: "\(projectTarget.path.basenameWithoutExt)-\(hash)")
            .appending(component: "Build")
            .appending(component: "Products")
            .appending(component: "\(configuration)-\(sdk)")
    }
}

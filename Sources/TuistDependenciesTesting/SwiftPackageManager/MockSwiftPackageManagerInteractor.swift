import ProjectDescription
import TSCBasic
import TuistCore
import TuistGraph

@testable import TuistDependencies

public final class MockSwiftPackageManagerInteractor: SwiftPackageManagerInteracting {
    public init() {}

    var invokedInstall = false
    var installStub: (
        (
            AbsolutePath,
            TuistGraph.SwiftPackageManagerDependencies,
            Set<TuistGraph.Platform>,
            Bool,
            String?
        ) throws -> TuistCore.DependenciesGraph
    )?

    public func install(
        dependenciesDirectory: AbsolutePath,
        dependencies: TuistGraph.SwiftPackageManagerDependencies,
        platforms: Set<TuistGraph.Platform>,
        shouldUpdate: Bool,
        swiftToolsVersion: String?
    ) throws -> TuistCore.DependenciesGraph {
        invokedInstall = true
        return try installStub?(dependenciesDirectory, dependencies, platforms, shouldUpdate, swiftToolsVersion) ?? .none
    }

    var invokedClean = false
    var cleanStub: ((AbsolutePath) throws -> Void)?

    public func clean(dependenciesDirectory: AbsolutePath) throws {
        invokedClean = true
        try cleanStub?(dependenciesDirectory)
    }
}

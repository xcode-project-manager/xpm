import Foundation
import TSCBasic

public final class GraphTraverser: GraphTraversing {
    private let graph: Graph
    public init(graph: Graph) {
        self.graph = graph
    }

    public func target(path: AbsolutePath, name: String) -> Target? {
        graph.target(path: path, name: name).map(\.target)
    }

    public func targets(at path: AbsolutePath) -> Set<Target> {
        Set(graph.targets(at: path).map(\.target))
    }

    public func directTargetDependencies(path: AbsolutePath, name: String) -> Set<Target> {
        Set(graph.targetDependencies(path: path, name: name).map { $0.target })
    }

    public func appExtensionDependencies(path: AbsolutePath, name: String) -> Set<Target> {
        Set(graph.appExtensionDependencies(path: path, name: name).map { $0.target })
    }

    public func resourceBundleDependencies(path: AbsolutePath, name: String) -> Set<Target> {
        Set(graph.resourceBundleDependencies(path: path, name: name).map { $0.target })
    }

    public func testTargetsDependingOn(path: AbsolutePath, name: String) -> Set<Target> {
        Set(graph.testTargetsDependingOn(path: path, name: name).map(\.target))
    }

    public func directStaticDependencies(path: AbsolutePath, name: String) -> Set<GraphDependencyReference> {
        Set(graph.staticDependencies(path: path, name: name))
    }

    public func appClipsDependency(path: AbsolutePath, name: String) -> Target? {
        graph.appClipsDependency(path: path, name: name).map { $0.target }
    }
}

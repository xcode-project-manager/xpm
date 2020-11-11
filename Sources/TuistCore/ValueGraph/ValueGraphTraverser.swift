import Foundation
import TSCBasic
import TuistSupport

public class ValueGraphTraverser: GraphTraversing {
    private let graph: ValueGraph
    public var name: String { graph.name }
    public var hasPackages: Bool {
        graph.dependencies.flatMap(\.value).contains(where: {
            guard case ValueGraphDependency.packageProduct = $0 else { return false }
            return true
        })
    }

    public var path: AbsolutePath { graph.path }
    public var workspace: Workspace { graph.workspace }
    public var projects: Set<Project> { Set(graph.projects.map(\.value)) }

    public required init(graph: ValueGraph) {
        self.graph = graph
    }

    public func target(path _: AbsolutePath, name _: String) -> ValueGraphTarget? {
        nil
//        graph.targets[path]?[name]
    }

    public func targets(at _: AbsolutePath) -> Set<ValueGraphTarget> {
        Set()
//        guard let targets = graph.targets[path] else { return [] }
//        return Set(targets.values)
    }

    public func directTargetDependencies(path _: AbsolutePath, name _: String) -> Set<ValueGraphTarget> {
        Set()
//        guard let dependencies = graph.dependencies[.target(name: name, path: path)] else { return [] }
//        return Set(dependencies.flatMap { (dependency) -> [Target] in
//            guard case let ValueGraphDependency.target(dependencyName, dependencyPath) = dependency else { return [] }
//            guard let projectDependencies = graph.targets[dependencyPath], let dependencyTarget = projectDependencies[dependencyName] else { return []
//            }
//            return [dependencyTarget]
//        })
    }

    public func resourceBundleDependencies(path _: AbsolutePath, name _: String) -> Set<ValueGraphTarget> {
        Set()
//        guard let target = graph.targets[path]?[name] else { return [] }
//        guard target.supportsResources else { return [] }
//
//        let canHostResources: (ValueGraphDependency) -> Bool = {
//            self.target(from: $0)?.supportsResources == true
//        }
//
//        let isBundle: (ValueGraphDependency) -> Bool = {
//            self.target(from: $0)?.product == .bundle
//        }
//
//        let bundles = filterDependencies(from: .target(name: name, path: path),
//                                         test: isBundle,
//                                         skip: canHostResources)
//        let bundleTargets = bundles.compactMap(target(from:))
//
//        return Set(bundleTargets)
    }

    public func testTargetsDependingOn(path _: AbsolutePath, name _: String) -> Set<ValueGraphTarget> {
        Set()
//        Set(graph.targets[path]?.values
//                .filter { $0.product.testsBundle }
//                .filter { graph.dependencies[.target(name: $0.name, path: path)]?.contains(.target(name: name, path: path)) == true } ?? [])
    }

    public func target(from _: ValueGraphDependency) -> ValueGraphTarget? {
        nil
//        guard case let ValueGraphDependency.target(name, path) = dependency else {
//            return nil
//        }
//        return graph.targets[path]?[name]
    }

    public func appExtensionDependencies(path _: AbsolutePath, name _: String) -> Set<ValueGraphTarget> {
        Set()
//        let validProducts: [Product] = [
//            .appExtension, .stickerPackExtension, .watch2Extension, .messagesExtension,
//        ]
//        return Set(directTargetDependencies(path: path, name: name)
//                    .filter { validProducts.contains($0.product) })
    }

    public func appClipsDependency(path _: AbsolutePath, name _: String) -> ValueGraphTarget? {
        nil
//        directTargetDependencies(path: path, name: name)
//            .first { $0.product == .appClip }
    }

    public func directStaticDependencies(path _: AbsolutePath, name _: String) -> Set<GraphDependencyReference> {
        Set()
//        Set(graph.dependencies[.target(name: name, path: path)]?
//                .compactMap { (dependency: ValueGraphDependency) -> (path: AbsolutePath, name: String)? in
//                    guard case let ValueGraphDependency.target(name, path) = dependency else {
//                        return nil
//                    }
//                    return (path, name)
//                }
//                .compactMap { graph.targets[$0.path]?[$0.name] }
//                .filter { $0.product.isStatic }
//                .map { .product(target: $0.name, productName: $0.productNameWithExtension) } ?? [])
    }

    /// It traverses the depdency graph and returns all the dependencies.
    /// - Parameter path: Path to the project from where traverse the dependency tree.
    public func allDependencies(path _: AbsolutePath) -> Set<ValueGraphDependency> {
        Set()
//        guard let targets = graph.targets[path]?.values else { return Set() }
//
//        var references = Set<ValueGraphDependency>()
//
//        targets.forEach { target in
//            let dependency = ValueGraphDependency.target(name: target.name, path: path)
//            references.formUnion(filterDependencies(from: dependency))
//        }
//
//        return references
    }

    /// The method collects the dependencies that are selected by the provided test closure.
    /// The skip closure allows skipping the traversing of a specific dependendency branch.
    /// - Parameters:
    ///   - from: Dependency from which the traverse is done.
    ///   - test: If the closure returns true, the dependency is included.
    ///   - skip: If the closure returns false, the traversing logic doesn't traverse the dependencies from that dependency.
    public func filterDependencies(from _: ValueGraphDependency,
                                   test _: (ValueGraphDependency) -> Bool = { _ in true },
                                   skip _: (ValueGraphDependency) -> Bool = { _ in false }) -> Set<ValueGraphDependency>
    {
        Set()
//        var stack = Stack<ValueGraphDependency>()
//
//        stack.push(rootDependency)
//
//        var visited: Set<ValueGraphDependency> = .init()
//        var references = Set<ValueGraphDependency>()
//
//        while !stack.isEmpty {
//            guard let node = stack.pop() else {
//                continue
//            }
//
//            if visited.contains(node) {
//                continue
//            }
//
//            visited.insert(node)
//
//            if node != rootDependency, test(node) {
//                references.insert(node)
//            }
//
//            if node != rootDependency, skip(node) {
//                continue
//            }
//
//            graph.dependencies[node]?.forEach { nodeDependency in
//                if !visited.contains(nodeDependency) {
//                    stack.push(nodeDependency)
//                }
//            }
//        }
//
//        return references
    }
}

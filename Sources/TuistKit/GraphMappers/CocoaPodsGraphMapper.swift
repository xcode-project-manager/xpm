import Foundation
import TuistCore

final class CocoaPodsGraphMapper: GraphMapping {
    func map(graph: Graph) throws -> (Graph, [SideEffectDescriptor]) {
        let targets = graph.targets.mapValues { (projectTargets: [TargetNode]) in
            projectTargets.map { (targetNode: TargetNode) -> TargetNode in
                // Check if the target depends on CocoaPods
                var target = targetNode.target
                target.scripts = [
                    TargetScript(name: "Whatever", script: "whatever", showEnvVarsInLog: true, hashable: false),
                ]
                targetNode.target = target
                return targetNode
            }
        }
        let graph = graph.with(targets: targets)

//        graph.with
        return (graph, [])
    }
}

////
/// let workspace = Workspace(cocoapods: .cocoapods(podsProject: "...",)

/// let target = Target(podfile: "")

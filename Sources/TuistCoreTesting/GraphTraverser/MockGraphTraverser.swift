import Foundation
import TSCBasic
@testable import TuistCore

final class MockGraphTraverser: GraphTraversing {
    var invokedNameGetter = false
    var invokedNameGetterCount = 0
    var stubbedName: String! = ""

    var name: String {
        invokedNameGetter = true
        invokedNameGetterCount += 1
        return stubbedName
    }

    var invokedHasPackagesGetter = false
    var invokedHasPackagesGetterCount = 0
    var stubbedHasPackages: Bool! = false

    var hasPackages: Bool {
        invokedHasPackagesGetter = true
        invokedHasPackagesGetterCount += 1
        return stubbedHasPackages
    }

    var invokedPathGetter = false
    var invokedPathGetterCount = 0
    var stubbedPath: AbsolutePath!

    var path: AbsolutePath {
        invokedPathGetter = true
        invokedPathGetterCount += 1
        return stubbedPath
    }

    var invokedWorkspaceGetter = false
    var invokedWorkspaceGetterCount = 0
    var stubbedWorkspace: Workspace!

    var workspace: Workspace {
        invokedWorkspaceGetter = true
        invokedWorkspaceGetterCount += 1
        return stubbedWorkspace
    }

    var invokedProjectsGetter = false
    var invokedProjectsGetterCount = 0
    var stubbedProjects: Set<Project>! = []

    var projects: Set<Project> {
        invokedProjectsGetter = true
        invokedProjectsGetterCount += 1
        return stubbedProjects
    }

    var invokedTarget = false
    var invokedTargetCount = 0
    var invokedTargetParameters: (path: AbsolutePath, name: String)?
    var invokedTargetParametersList = [(path: AbsolutePath, name: String)]()
    var stubbedTargetResult: ValueGraphTarget!

    func target(path: AbsolutePath, name: String) -> ValueGraphTarget? {
        invokedTarget = true
        invokedTargetCount += 1
        invokedTargetParameters = (path, name)
        invokedTargetParametersList.append((path, name))
        return stubbedTargetResult
    }

    var invokedTargets = false
    var invokedTargetsCount = 0
    var invokedTargetsParameters: (path: AbsolutePath, Void)?
    var invokedTargetsParametersList = [(path: AbsolutePath, Void)]()
    var stubbedTargetsResult: Set<ValueGraphTarget>! = []

    func targets(at path: AbsolutePath) -> Set<ValueGraphTarget> {
        invokedTargets = true
        invokedTargetsCount += 1
        invokedTargetsParameters = (path, ())
        invokedTargetsParametersList.append((path, ()))
        return stubbedTargetsResult
    }

    var invokedDirectTargetDependencies = false
    var invokedDirectTargetDependenciesCount = 0
    var invokedDirectTargetDependenciesParameters: (path: AbsolutePath, name: String)?
    var invokedDirectTargetDependenciesParametersList = [(path: AbsolutePath, name: String)]()
    var stubbedDirectTargetDependenciesResult: Set<ValueGraphTarget>! = []

    func directTargetDependencies(path: AbsolutePath, name: String) -> Set<ValueGraphTarget> {
        invokedDirectTargetDependencies = true
        invokedDirectTargetDependenciesCount += 1
        invokedDirectTargetDependenciesParameters = (path, name)
        invokedDirectTargetDependenciesParametersList.append((path, name))
        return stubbedDirectTargetDependenciesResult
    }

    var invokedAppExtensionDependencies = false
    var invokedAppExtensionDependenciesCount = 0
    var invokedAppExtensionDependenciesParameters: (path: AbsolutePath, name: String)?
    var invokedAppExtensionDependenciesParametersList = [(path: AbsolutePath, name: String)]()
    var stubbedAppExtensionDependenciesResult: Set<ValueGraphTarget>! = []

    func appExtensionDependencies(path: AbsolutePath, name: String) -> Set<ValueGraphTarget> {
        invokedAppExtensionDependencies = true
        invokedAppExtensionDependenciesCount += 1
        invokedAppExtensionDependenciesParameters = (path, name)
        invokedAppExtensionDependenciesParametersList.append((path, name))
        return stubbedAppExtensionDependenciesResult
    }

    var invokedResourceBundleDependencies = false
    var invokedResourceBundleDependenciesCount = 0
    var invokedResourceBundleDependenciesParameters: (path: AbsolutePath, name: String)?
    var invokedResourceBundleDependenciesParametersList = [(path: AbsolutePath, name: String)]()
    var stubbedResourceBundleDependenciesResult: Set<ValueGraphTarget>! = []

    func resourceBundleDependencies(path: AbsolutePath, name: String) -> Set<ValueGraphTarget> {
        invokedResourceBundleDependencies = true
        invokedResourceBundleDependenciesCount += 1
        invokedResourceBundleDependenciesParameters = (path, name)
        invokedResourceBundleDependenciesParametersList.append((path, name))
        return stubbedResourceBundleDependenciesResult
    }

    var invokedTestTargetsDependingOn = false
    var invokedTestTargetsDependingOnCount = 0
    var invokedTestTargetsDependingOnParameters: (path: AbsolutePath, name: String)?
    var invokedTestTargetsDependingOnParametersList = [(path: AbsolutePath, name: String)]()
    var stubbedTestTargetsDependingOnResult: Set<ValueGraphTarget>! = []

    func testTargetsDependingOn(path: AbsolutePath, name: String) -> Set<ValueGraphTarget> {
        invokedTestTargetsDependingOn = true
        invokedTestTargetsDependingOnCount += 1
        invokedTestTargetsDependingOnParameters = (path, name)
        invokedTestTargetsDependingOnParametersList.append((path, name))
        return stubbedTestTargetsDependingOnResult
    }

    var invokedDirectStaticDependencies = false
    var invokedDirectStaticDependenciesCount = 0
    var invokedDirectStaticDependenciesParameters: (path: AbsolutePath, name: String)?
    var invokedDirectStaticDependenciesParametersList = [(path: AbsolutePath, name: String)]()
    var stubbedDirectStaticDependenciesResult: Set<GraphDependencyReference>! = []

    func directStaticDependencies(path: AbsolutePath, name: String) -> Set<GraphDependencyReference> {
        invokedDirectStaticDependencies = true
        invokedDirectStaticDependenciesCount += 1
        invokedDirectStaticDependenciesParameters = (path, name)
        invokedDirectStaticDependenciesParametersList.append((path, name))
        return stubbedDirectStaticDependenciesResult
    }

    var invokedAppClipsDependency = false
    var invokedAppClipsDependencyCount = 0
    var invokedAppClipsDependencyParameters: (path: AbsolutePath, name: String)?
    var invokedAppClipsDependencyParametersList = [(path: AbsolutePath, name: String)]()
    var stubbedAppClipsDependencyResult: ValueGraphTarget!

    func appClipsDependency(path: AbsolutePath, name: String) -> ValueGraphTarget? {
        invokedAppClipsDependency = true
        invokedAppClipsDependencyCount += 1
        invokedAppClipsDependencyParameters = (path, name)
        invokedAppClipsDependencyParametersList.append((path, name))
        return stubbedAppClipsDependencyResult
    }
}

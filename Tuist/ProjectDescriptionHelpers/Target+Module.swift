import Foundation
import ProjectDescription

public extension Target {
    static func module(
                module: Module,
                deploymentTarget: DeploymentTarget,
                product: Product = .staticLibrary,
                dependencies: [Dependency] = [],
                additionalTestDependencies: [Dependency] = [],
                additionalTestingDependencies: [Dependency] = []) -> [Target] {
        
        var testDependencies = dependencies.map(\.targetDependency) + [module.dependency] + additionalTestDependencies.map(\.targetDependency)
        if let testingDependency = module.testingDependency {
            testDependencies.append(testingDependency)
        }
        let testingDependencies = dependencies.map(\.targetDependency) + [module.dependency] + additionalTestingDependencies.map(\.targetDependency)
        
        var targets = [
            Target(name: module.name,
                   platform: .macOS,
                   product: product,
                   bundleId: "io.tuist.\(module.name)",
                   deploymentTarget: deploymentTarget,
                   infoPlist: .default,
                   sources: ["Sources/\(module.name)/**/*.swift"],
                   dependencies: dependencies.map(\.targetDependency),
                   settings: Settings(configurations: [
                       .debug(name: "Debug", settings: [:], xcconfig: nil),
                       .release(name: "Release", settings: [:], xcconfig: nil),
                   ]))
        ]
        if let testsName = module.testsName {
            targets.append(Target(name: testsName,
                                  platform: .macOS,
                                  product: .unitTests,
                                  bundleId: "io.tuist.\(testsName)",
                                  deploymentTarget: deploymentTarget,
                                  infoPlist: .default,
                                  sources: ["Tests/\(testsName)/**/*.swift"],
                                  dependencies: testDependencies,
                                  settings: Settings(configurations: [
                                      .debug(name: "Debug", settings: [:], xcconfig: nil),
                                      .release(name: "Release", settings: [:], xcconfig: nil),
                                  ])))
        }
        if let testingName = module.testingName {
            targets.append(Target(name: testingName,
                                  platform: .macOS,
                                  product: product,
                                  bundleId: "io.tuist.\(testingName)",
                                  deploymentTarget: deploymentTarget,
                                  infoPlist: .default,
                                  sources: ["Sources/\(testingName)/**/*.swift"],
                                  dependencies: testingDependencies,
                                  settings: Settings(configurations: [
                                      .debug(name: "Debug", settings: [:], xcconfig: nil),
                                      .release(name: "Release", settings: [:], xcconfig: nil),
                                  ])))
        }
        
        return targets
    }

}

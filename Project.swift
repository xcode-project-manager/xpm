import ProjectDescription
import ProjectDescriptionHelpers

let baseSettings: SettingsDictionary = ["EXCLUDED_ARCHS": "arm64"]

func debugSettings() -> SettingsDictionary {
    var settings = baseSettings
    settings["ENABLE_TESTABILITY"] = "YES"
    return settings
}

func releaseSettings() -> SettingsDictionary {
    let settings = baseSettings
    return settings
}

func targets(deploymentTarget: DeploymentTarget) -> [Target] {
    var targets: [Target] = []
    
    targets.append(contentsOf: Target.module(module: .projectDescription,
                                             deploymentTarget: deploymentTarget,
                                             product: .framework,
                                             additionalTestDependencies: [
                                                .local(Module.support.testingDependency!)
                                             ]))
    
    targets.append(contentsOf: Target.module(module: .support,
                                             deploymentTarget: deploymentTarget,
                                             dependencies: [
                                                .thirdParty(.combineExt),
                                                .thirdParty(.swiftToolsSupport),
                                                .thirdParty(.rxSwift),
                                                .thirdParty(.rxRelay),
                                                .thirdParty(.logging),
                                                .thirdParty(.keychainAccess),
                                                .thirdParty(.swifter),
                                                .thirdParty(.blueSignals),
                                                .thirdParty(.zip),
                                                .thirdParty(.checksum),
                                             ],
                                             additionalTestDependencies: [
                                                .thirdParty(.rxBlocking),
                                             ]))
    targets.append(contentsOf: Target.module(module: .graph,
                                             deploymentTarget: deploymentTarget,
                                             dependencies: [
                                                .thirdParty(.swiftToolsSupport),
                                             ],
                                             additionalTestDependencies: [
                                                .local(Module.support.testingDependency!),
                                                .thirdParty(.xcodeproj),
                                             ],
                                             additionalTestingDependencies: [
                                                .local(Module.support.testingDependency!),
                                                // Otherwise the compilation fails
                                                .thirdParty(.zip)
                                             ]))
    return targets
}

let deploymentTarget: DeploymentTarget = .macOS(targetVersion: "10.15")
let project = Project(
    name: "Tuist",
    packages: Array(Set(PackageDependency.allCases.map(\.package))),
    settings: Settings(configurations: [
        .debug(name: "Debug", settings: debugSettings(), xcconfig: nil),
        .release(name: "Release", settings: releaseSettings(), xcconfig: nil),
    ]),
    targets: targets(deploymentTarget: deploymentTarget)
)

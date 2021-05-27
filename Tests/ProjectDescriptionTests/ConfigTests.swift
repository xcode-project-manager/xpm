import Foundation
import XCTest
@testable import ProjectDescription

final class ConfigTests: XCTestCase {
    func test_config_toJSON() throws {
        let config = Config(
            lab: Lab(url: "https://lab.tuist.io", projectId: "123", options: [.insights]),
            generationOptions: [
                .xcodeProjectName("someprefix-\(.projectName)"),
                .organizationName("TestOrg"),
                .developmentRegion("de"),
                .disableAutogeneratedSchemes,
                .disableSynthesizedResourceAccessors,
                .disableShowEnvironmentVarsInScriptPhases,
                .enableCodeCoverage,
                .disablePackageVersionLocking,
            ]
        )

        XCTAssertCodable(config)
    }

    func test_config_toJSON_WITH_gitPlugin() {
        let config = Config(
            plugins: [.git(url: "https://git.com/repo.git", tag: "1.0.0")],
            generationOptions: []
        )

        XCTAssertCodable(config)
    }

    func test_config_toJSON_WITH_localPlugin() {
        let config = Config(
            plugins: [.local(path: "/some/path/to/plugin")],
            generationOptions: []
        )

        XCTAssertCodable(config)
    }

    func test_config_toJSON_WITH_swiftVersion() {
        let config = Config(
            swiftVersion: "5.3.0",
            generationOptions: []
        )

        XCTAssertCodable(config)
    }

    func test_config_toJSON_withAutogeneratedSchemes() throws {
        let config = Config(
            lab: Lab(url: "https://lab.tuist.io", projectId: "123", options: [.insights]),
            generationOptions: [
                .xcodeProjectName("someprefix-\(.projectName)"),
                .developmentRegion("de"),
                .organizationName("TestOrg"),
            ]
        )

        XCTAssertCodable(config)
    }
}

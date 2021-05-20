import Foundation
import TuistCache
import TuistCloud
import TuistCoreTesting
import TuistGenerator
import TuistGraph
import TuistGraphTesting
import TuistSupport
import XCTest

@testable import TuistCore
@testable import TuistKit
@testable import TuistSigning
@testable import TuistSupportTesting

final class ProjectMapperProviderTests: TuistUnitTestCase {
    var subject: ProjectMapperProvider!

    override func setUp() {
        super.setUp()
        subject = ProjectMapperProvider(contentHasher: ContentHasher())
    }

    override func tearDown() {
        subject = nil
        super.tearDown()
    }

    func test_mapper_returns_a_sequential_mapper_with_the_autogenerated_schemes_project_mapper() throws {
        // Given
        subject = ProjectMapperProvider(contentHasher: ContentHasher())

        // When
        let got = subject.mapper(
            config: Config.test(lab: .test(options: []))
        )

        // Then
        let sequentialProjectMapper = try XCTUnwrap(got as? SequentialProjectMapper)
        XCTAssertEqual(sequentialProjectMapper.mappers.filter { $0 is AutogeneratedSchemesProjectMapper }.count, 1)
    }

    func test_mappers_returns_theSigningMapper() throws {
        // Given
        subject = ProjectMapperProvider(contentHasher: ContentHasher())

        // When
        let got = subject.mapper(
            config: Config.test()
        )

        // Then
        let sequentialProjectMapper = try XCTUnwrap(got as? SequentialProjectMapper)
        XCTAssertEqual(sequentialProjectMapper.mappers.filter { $0 is SigningMapper }.count, 1)
    }

    func test_mappers_returns_resources_namespace_project_mapper() throws {
        // Given
        subject = ProjectMapperProvider(contentHasher: ContentHasher())

        // When
        let got = subject.mapper(
            config: Config.test()
        )

        // Then
        let sequentialProjectMapper = try XCTUnwrap(got as? SequentialProjectMapper)
        XCTAssertEqual(sequentialProjectMapper.mappers.filter { $0 is SynthesizedResourceInterfaceProjectMapper }.count, 1)
    }

    func test_mappers_does_not_returns_resources_namespace_project_mapper_when_disabled_autogenerated_namespace() throws {
        // Given
        subject = ProjectMapperProvider(contentHasher: ContentHasher())

        // When
        let got = subject.mapper(
            config: Config.test(
                generationOptions: [
                    .disableSynthesizedResourceAccessors,
                ]
            )
        )

        // Then
        let sequentialProjectMapper = try XCTUnwrap(got as? SequentialProjectMapper)
        XCTAssertEqual(sequentialProjectMapper.mappers.filter { $0 is SynthesizedResourceInterfaceProjectMapper }.count, 0)
    }

    func test_mappers_does_disable_show_environment_vars() throws {
        // Given
        subject = ProjectMapperProvider(contentHasher: ContentHasher())

        // When
        let got = subject.mapper(
            config: Config.test(
                generationOptions: [
                    .disableShowEnvironmentVarsInScriptPhases,
                ]
            )
        )

        // Then
        let sequentialProjectMapper = try XCTUnwrap(got as? SequentialProjectMapper)
        XCTAssertEqual(sequentialProjectMapper.mappers.filter { $0 is TargetProjectMapper }.count, 1)
    }

    func test_mappers_does_enable_code_coverage() throws {
        // Given
        subject = ProjectMapperProvider(contentHasher: CacheContentHasher())

        // When
        let got = subject.mapper(
            config: Config.test(
                generationOptions: [
                    .enableCodeCoverage,
                ]
            )
        )

        // Then
        let sequentialProjectMapper = try XCTUnwrap(got as? SequentialProjectMapper)
        XCTAssertEqual(sequentialProjectMapper.mappers.filter { $0 is AutogeneratedSchemesProjectMapper }.count, 1)
    }

    func test_mappers_does_add_template_macros() throws {
        // Given
        subject = ProjectMapperProvider(contentHasher: CacheContentHasher())

        // When
        let got = subject.mapper(
            config: Config.test()
        )

        // Then
        let sequentialProjectMapper = try XCTUnwrap(got as? SequentialProjectMapper)
        XCTAssertEqual(sequentialProjectMapper.mappers.filter { $0 is IDETemplateMacrosMapper }.count, 1)
    }
}

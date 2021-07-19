import Foundation
import TuistSupport
import TuistSupportTesting
import XCTest

final class GitHubReleaseTests: TuistUnitTestCase {
    func test_codable() {
        // Given
        let subject = GitHubRelease(
            name: "1.2.3",
            tagName: "1.2.3",
            draft: false,
            prerelease: false,
            assets: [.init(name: "tuist.zip", browserDownloadURL: "https://tuist.io/tuist.zip")]
        )

        // When/then
        XCTAssertCodable(subject)
    }

    func test_latest() {
        /// Given
        let subject = GitHubRelease.latest(repositoryFullName: "tuist/tuist")

        // Then
        XCTAssertHTTPMethod(resource: subject, httpMethod: "GET")
        XCTAssertPath(resource: subject, path: "/repos/tuist/tuist/releases/latest")
    }
}

import Foundation
import TuistSupport
import TuistSupportTesting
import XCTest

final class GitHubReleaseAssetTests: TuistUnitTestCase {
    func test_codable() {
        // Given
        let subject = GitHubReleaseAsset(name: "tuist.zip", browserDownloadURL: "https://tuist.io/tuist.zip")

        // When/then
        XCTAssertCodable(subject)
    }
}

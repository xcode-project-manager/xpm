import Foundation

public struct GitHubReleaseAsset: Codable, Equatable {
    /// The name of the asset..
    public let name: String

    /// The URL to download the asset
    public let browserDownloadURL: String

    public init(name: String,
                browserDownloadURL: String)
    {
        self.name = name
        self.browserDownloadURL = browserDownloadURL
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case browserDownloadURL = "browser_download_url"
    }
}

import Basic
import Foundation

public struct Xcode {
    /// It represents the content of the Info.plist file inside the Xcode app bundle.
    struct InfoPlist: Codable {
        /// App version number (e.g. 10.3)
        let version: String

        enum CodingKeys: String, CodingKey {
            case version = "CFBundleShortVersionString"
        }
    }

    /// Path to the Xcode app bundle.
    let path: AbsolutePath

    /// Info plist content.
    let infoPlist: InfoPlist

    /// Initializes an Xcode instance by reading it from a local Xcode.app bundle.
    ///
    /// - Parameter path: Path to a local Xcode.app bundle.
    /// - Returns: Initialized Xcode instance.
    /// - Throws: An error if the local installation can't be read.
    static func read(path: AbsolutePath) throws -> Xcode {
        let infoPlistPath = path.appending(RelativePath("Contents/Info.plist"))
        let plistDecoder = PropertyListDecoder()
        let data = try Data(contentsOf: infoPlistPath.url)
        let infoPlist = try plistDecoder.decode(InfoPlist.self, from: data)

        return Xcode(path: path, infoPlist: infoPlist)
    }

    /// Initializes an instance of Xcode which represents a local installation of Xcode
    ///
    /// - Parameters:
    ///     - path: Path to the Xcode app bundle.
    init(path: AbsolutePath,
         infoPlist: InfoPlist) {
        self.path = path
        self.infoPlist = infoPlist
    }
}

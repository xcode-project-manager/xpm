import Foundation
import TuistGraph
import TSCBasic

public protocol ConfigLoading {
    func loadConfig(at path: AbsolutePath) throws -> Config
}

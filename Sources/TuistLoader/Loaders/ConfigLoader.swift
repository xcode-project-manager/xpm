import Foundation
import TSCBasic
import TuistGraph

public protocol ConfigLoading {
    func loadConfig(at path: AbsolutePath) throws -> Config
}

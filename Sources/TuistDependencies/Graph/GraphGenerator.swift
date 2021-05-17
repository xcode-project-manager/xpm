import TSCBasic
import TuistCore
import TuistGraph
import TuistSupport

public protocol GraphGenerating {
    func generate(at path: AbsolutePath) throws
}

public class GraphGenerator: GraphGenerating {
    public init() {}
    
    public func generate(at path: AbsolutePath) throws {
        
    }
}



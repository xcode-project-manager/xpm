import Foundation
import TuistCore
import TuistGraph
@testable import TuistCache

public final class MockCacheGraphContentHasher: CacheGraphContentHashing {
    public init() {}

    public var contentHashesGraphStub: ((Graph, TuistGraph.Cache.Profile, CacheOutputType) throws -> [TargetNode: String])?
    public func contentHashes(
        for graph: Graph,
        cacheProfile: TuistGraph.Cache.Profile,
        cacheOutputType: CacheOutputType
    ) throws -> [TargetNode: String] {
        try contentHashesGraphStub?(graph, cacheProfile, cacheOutputType) ?? [:]
    }

    public var contentHashesStub: ((ValueGraph, TuistGraph.Cache.Profile, CacheOutputType) throws -> [ValueGraphTarget: String])?
    public func contentHashes(
        for graph: ValueGraph,
        cacheProfile: TuistGraph.Cache.Profile,
        cacheOutputType: CacheOutputType
    ) throws -> [ValueGraphTarget: String] {
        try contentHashesStub?(graph, cacheProfile, cacheOutputType) ?? [:]
    }
}

import Foundation
import ProjectDescription

public enum PackageDependency: CaseIterable {
    case xcodeproj
    case combineExt
    case swiftToolsSupport
    case rxSwift
    case rxBlocking
    case rxRelay
    case keychainAccess
    case swifter
    case blueSignals
    case zip
    case checksum
    case logging
    
    public var package: Package {
        switch self {
        case .xcodeproj:
            return .package(url: "https://github.com/tuist/XcodeProj.git", .upToNextMajor(from: "7.17.0"))
        case .combineExt:
            return .package(url: "https://github.com/CombineCommunity/CombineExt.git", .upToNextMajor(from: "1.3.0"))
        case .swiftToolsSupport:
            return .package(url: "https://github.com/apple/swift-tools-support-core.git", .upToNextMinor(from: "0.2.0"))
        case .rxSwift, .rxBlocking, .rxRelay:
            return .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.1.1"))
        case .keychainAccess:
            return .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", .upToNextMajor(from: "4.2.2"))
        case .swifter:
            return .package(url: "https://github.com/httpswift/swifter.git", .upToNextMajor(from: "1.5.0"))
        case .blueSignals:
            return .package(url: "https://github.com/tuist/BlueSignals.git", .upToNextMajor(from: "1.0.21"))
        case .zip:
            return .package(url: "https://github.com/marmelroy/Zip.git", .upToNextMinor(from: "2.1.1"))
        case .checksum:
            return .package(url: "https://github.com/rnine/Checksum.git", .upToNextMajor(from: "1.0.2"))
        case .logging:
            return .package(url: "https://github.com/apple/swift-log.git", .upToNextMajor(from: "1.4.0"))
        }
    }
    
    public var targetDependency: TargetDependency {
        switch self {
        case .xcodeproj:
            return .package(product: "XcodeProj")
        case .combineExt:
            return .package(product: "CombineExt")
        case .swiftToolsSupport:
            return .package(product: "SwiftToolsSupport-auto")
        case .rxSwift:
            return .package(product: "RxSwift")
        case .rxBlocking:
            return .package(product: "RxBlocking")
        case .rxRelay:
            return .package(product: "RxRelay")
        case .keychainAccess:
            return .package(product: "KeychainAccess")
        case .swifter:
            return .package(product: "Swifter")
        case .blueSignals:
            return .package(product: "Signals")
        case .zip:
            return .package(product: "Zip")
        case .checksum:
            return .package(product: "Checksum")
        case .logging:
            return .package(product: "Logging")
        }
    }
}

public enum Dependency {
    case local(TargetDependency)
    case thirdParty(PackageDependency)
    
    public var targetDependency: TargetDependency {
        switch self {
        case let .local(localDependency): return localDependency
        case let .thirdParty(package): return package.targetDependency
        }
    }
}

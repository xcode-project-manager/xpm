// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "tuist",
    products: [
        .executable(name: "tuist", targets: ["tuist"]),
        .executable(name: "tuistenv", targets: ["tuistenv"]),
        .library(name: "ProjectDescription",
                 type: .dynamic,
                 targets: ["ProjectDescription"]),

        /// TuistGenerator
        ///
        /// A high level Xcode generator library
        /// responsible for generating Xcode projects & workspaces.
        ///
        /// This library can be used in external tools that wish to
        /// leverage Tuist's Xcode generation features.
        ///
        /// Note: This library should be treated as **unstable** as
        ///       it is still under development and may include breaking
        ///       changes in future releases.
        .library(name: "TuistGenerator",
                 targets: ["TuistGenerator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMinor(from: "6.6.0")),
        .package(url: "https://github.com/apple/swift-package-manager", .revision("a107d28d1b40491cf505799a046fee53e7c422e1")),
    ],
    targets: [
        .target(
            name: "TuistKit",
            dependencies: ["xcodeproj", "Utility", "TuistCore", "TuistGenerator", "ProjectDescription"]
        ),
        .testTarget(
            name: "TuistKitTests",
            dependencies: ["TuistKit", "TuistCoreTesting", "ProjectDescription"]
        ),
        .target(
            name: "tuist",
            dependencies: ["TuistKit"]
        ),
        .target(
            name: "TuistEnvKit",
            dependencies: ["Utility", "TuistCore"]
        ),
        .testTarget(
            name: "TuistEnvKitTests",
            dependencies: ["TuistEnvKit", "TuistCoreTesting"]
        ),
        .target(
            name: "tuistenv",
            dependencies: ["TuistEnvKit"]
        ),
        .target(
            name: "ProjectDescription",
            dependencies: []
        ),
        .testTarget(
            name: "ProjectDescriptionTests",
            dependencies: ["ProjectDescription"]
        ),
        .target(
            name: "TuistCore",
            dependencies: ["Utility"]
        ),
        .target(
            name: "TuistCoreTesting",
            dependencies: ["TuistCore"]
        ),
        .testTarget(
            name: "TuistCoreTests",
            dependencies: ["TuistCore", "TuistCoreTesting"]
        ),
        .target(
            name: "TuistGenerator",
            dependencies: ["xcodeproj", "Utility", "TuistCore"]
        ),
        .testTarget(
            name: "TuistGeneratorTests",
            dependencies: ["TuistGenerator", "TuistCoreTesting"]
        ),
    ]
)

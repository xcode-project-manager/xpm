import ProjectDescription

let project = Project(
    name: "MainApp",
    targets: [
        Target(
            name: "App",
            platform: .iOS,
            product: .app,
            bundleId: "io.tuist.App",
            infoPlist: "Config/App-Info.plist",
            sources: "Sources/**",
            resources: [
                "Resources/**/*.png",
                "Resources/*.xcassets",
                "Resources/**/*.txt",
                "Resources/**/*.strings",
                "Resources/resource_without_extension",
                .folderReference(path: "Examples")
            ],
            dependencies: [
                .project(target: "Framework1", path: "../Framework1"),
            ]
        ),
        Target(
            name: "AppTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.AppTests",
            infoPlist: "Config/AppTests-Info.plist",
            sources: "Tests/**",
            dependencies: [
                .target(name: "App"),
            ]
        ),
    ]
)

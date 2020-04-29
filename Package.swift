// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "__PROJECT_NAME__",
    products: [
        .library(name: "__PROJECT_NAME__",
            targets: ["__PROJECT_NAME__"]),
    ],
    dependencies: [
      .package(name: "JavaScriptKit", url: "https://github.com/kateinoigakukun/JavaScriptKit.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "__PROJECT_NAME__Web",
            dependencies: ["__PROJECT_NAME__", "JavaScriptKit"]),
        .target(name: "__PROJECT_NAME__", dependencies: []),
        .testTarget(name: "__PROJECT_NAME__Tests", dependencies: [
           "__PROJECT_NAME__"
        ]),
    ]
)

// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "GitHubExample",
    products: [
        .library(name: "GitHubExample",
            targets: ["GitHubExample"])
    ],
    dependencies: [
//      .package(name: "JavaScriptKit", url: "https://github.com/kateinoigakukun/JavaScriptKit.git", .branch("master"))
      .package(name: "JavaScriptKit", path: "../../kateinoigakukun/JavaScriptKit")
    ],
    targets: [
        .target(
            name: "GitHubExampleWeb",
            dependencies: ["GitHubExample", "JavaScriptKit"]),
        .target(name: "GitHubExample", dependencies: []),
        .testTarget(name: "GitHubExampleTests", dependencies: [
           "GitHubExample"
        ])
    ]
)

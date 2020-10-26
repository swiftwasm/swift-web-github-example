// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "GitHubExample",
    products: [
        .library(name: "GitHubExample",
            targets: ["GitHubExample"])
    ],
    dependencies: [
        .package(name: "JavaScriptKit", url: "https://github.com/swiftwasm/JavaScriptKit.git", from: "0.8.0"),
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

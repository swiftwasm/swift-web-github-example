# GitHub Search 🔍

Demo project of Swift on Web App

https://swift-web-github-example.netlify.app/

<img src="https://gist.githubusercontent.com/kateinoigakukun/a429575332b610c68207421c4235369d/raw/e723adeed6ffbac8b48454cd3c048c28991d7a32/demo.png" width="80%" />

## Requirements

This project only supports [`swiftwasm/swift`](https://github.com/swiftwasm/swift) distribution toolchain. Please install Swift for WebAssembly toolchain from [Release Page](https://github.com/swiftwasm/swift/releases)

The toolchains can be installed via [`swiftenv`](https://github.com/kylef/swiftenv).

```sh

$ swiftenv install https://github.com/swiftwasm/swift/releases/download/swift-wasm-5.3.0-RELEASE/swift-wasm-5.3.0-RELEASE-macos_x86_64.pkg
$ swift --version
SwiftWasm Swift version 5.3 (swiftlang-5.3.0)
Target: x86_64-apple-darwin19.6.0
```

## Getting Started

```sh
npm install
npm run start
```

## Testing

```sh
swift test
```

## iOS App

[XcodeGen](https://github.com/yonaskolb/XcodeGen/) is required to make `.xcodeproj`

```sh
$ xcodegen
$ open GitHubExampleiOS.xcodeproj
```


## Development Tips

You can edit source code and run test case on Xcode

```sh
swift package generate-xcodeproj
```

# GitHub Search 🔍

Demo project of Swift on Web App

https://swift-web-github-example.netlify.app/

## Requirements

This project only supports [`swiftwasm/swift`](https://github.com/swiftwasm/swift) distribution toolchain. Please install Swift for WebAssembly toolchain from [Release Page](https://github.com/swiftwasm/swift/releases)

The toolchains can be installed via [`swiftenv`](https://github.com/kylef/swiftenv).

```sh
$ swiftenv install https://github.com/swiftwasm/swift/releases/download/swift-wasm-DEVELOPMENT-SNAPSHOT-2020-04-27-a/swift-wasm-DEVELOPMENT-SNAPSHOT-2020-04-27-a-osx.tar.gz
$ swiftenv local wasm-DEVELOPMENT-SNAPSHOT-2020-04-27-a
$ swift --version
Swift version 5.2-dev (LLVM 7fc8796bc1, Swift 5be35e7aee)
Target: x86_64-apple-darwin19.3.0
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

## Development Tips

You can edit source code and run test case on Xcode

```sh
swift package generate-xcodeproj
```

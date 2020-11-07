# GitHub Search 🔍

Demo project of Swift on Web App

https://swift-web-github-example.netlify.app/

<img src="https://gist.githubusercontent.com/kateinoigakukun/a429575332b610c68207421c4235369d/raw/e723adeed6ffbac8b48454cd3c048c28991d7a32/demo.png" width="80%" />

## Requirements

This project only supports [`swiftwasm/swift`](https://github.com/swiftwasm/swift) distribution toolchain.
Please install Swift for WebAssembly toolchain using [Installation instruction](https://book.swiftwasm.org/getting-started/setup.html)

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

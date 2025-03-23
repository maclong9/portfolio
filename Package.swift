// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Portfolio",
  platforms: [.macOS(.v13)],
  dependencies: [
    .package(path: "../web-ui"),
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
  ],
  targets: [
    .executableTarget(
      name: "Portfolio",
      dependencies: [
        .product(name: "WebUI", package: "web-ui"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ],
      resources: [
        .copy("Public")
      ]
    )
  ]
)

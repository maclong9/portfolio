// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Portfolio",
  platforms: [.macOS(.v15)],
  dependencies: [
    .package(url: "https://github.com/maclong9/web-ui", from: "0.0.3")
  ],
  targets: [
    .executableTarget(
      name: "Portfolio",
      dependencies: [.product(name: "WebUI", package: "web-ui")],
      resources: [
        .copy("Public")
      ])
  ]
)

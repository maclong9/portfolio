// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Portfolio",
  platforms: [.macOS(.v15)],
  dependencies: [
    .package(path: "../web-ui/")
  ],
  targets: [
    .executableTarget(
      name: "Portfolio",
      dependencies: [.product(name: "WebUI", package: "web-ui")])
  ]
)

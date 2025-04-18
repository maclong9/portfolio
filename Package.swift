// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Portfolio",
  platforms: [.macOS(.v13)],
  products: [
    .executable(name: "Portfolio", targets: ["Portfolio"]),
  ],
  dependencies: [
    .package(url: "https://github.com/maclong9/web-ui", branch: "main"),
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0"),
  ],
  targets: [
    .executableTarget(
      name: "Portfolio",
      dependencies: [
        .product(name: "WebUI", package: "web-ui")
      ],
      resources: [
        .copy("Public")
      ]
    ),
  ]
)

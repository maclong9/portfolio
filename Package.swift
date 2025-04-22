// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Portfolio",
  platforms: [.macOS(.v13)],
  products: [
    .executable(name: "Portfolio", targets: ["Portfolio"])
  ],
  dependencies: [
    .package(url: "https://github.com/maclong9/web-ui.git", from: "1.0.0")
  ],
  targets: [
    .executableTarget(
      name: "Portfolio",
      dependencies: [
        .product(name: "WebUI", package: "web-ui")
      ],
      resources: [
        .copy("Public"),
        .copy("Articles"),
      ]
    )
  ]
)

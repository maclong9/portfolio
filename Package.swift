// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "portfolio",
  platforms: [.macOS(.v15)],
  dependencies: [
    .package(url: "https://github.com/maclong9/web-ui", branch: "main")
  ],
  targets: [
    .executableTarget(
      name: "Application",
      dependencies: [
        .product(name: "WebUI", package: "web-ui"),
        .product(name: "WebUIMarkdown", package: "web-ui")
      ]
    )
  ]
)

// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "portfolio",
  platforms: [.macOS(.v15)],
  products: [
    .library(
      name: "Shared",
      targets: ["Shared"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/maclong9/web-ui", branch: "main")
  ],
  targets: [
    .executableTarget(
      name: "Application",
      dependencies: [
        .product(name: "WebUI", package: "web-ui"),
        .product(name: "WebUIMarkdown", package: "web-ui"),
        "Shared",
      ],
    ),
    .target(
      name: "Shared",
      dependencies: [
        .product(name: "WebUI", package: "web-ui"),
        .product(name: "WebUIMarkdown", package: "web-ui"),
      ],
    ),
  ]
)

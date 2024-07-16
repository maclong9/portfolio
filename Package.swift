// swift-tools-version:6.0
import PackageDescription

let package = Package(
  name: "portfolio",
  platforms: [
    .macOS(.v13)
  ],
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.99.3"),
    .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
    .package(url: "https://github.com/vapor/redis.git", from: "4.0.0"),
    .package(url: "https://github.com/binarybirds/swift-html", from: "1.7.0"),
  ],
  targets: [
    .executableTarget(
      name: "App",
      dependencies: [
        .product(name: "Vapor", package: "vapor"),
        .product(name: "NIOCore", package: "swift-nio"),
        .product(name: "NIOPosix", package: "swift-nio"),
        .product(name: "Redis", package: "redis"),
        .product(name: "SwiftHtml", package: "swift-html"),
      ]
    )
  ]
)

// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "OkunCore",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    .library(name: "OkunCore", targets: ["OkunCore"]),
  ],
  targets: [
    .target(name: "OkunCore", dependencies: []),
    .testTarget(name: "OkunCoreTests", dependencies: ["OkunCore"]),
  ]
)

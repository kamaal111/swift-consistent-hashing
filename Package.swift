// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftConsistentHashing",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(name: "SwiftConsistentHashing", targets: ["SwiftConsistentHashing"]),
    ],
    targets: [
        .target(name: "SwiftConsistentHashing"),
        .testTarget(name: "SwiftConsistentHashingTests", dependencies: ["SwiftConsistentHashing"]),
    ]
)

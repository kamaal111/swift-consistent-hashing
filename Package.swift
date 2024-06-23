// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftConsistentHashing",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(name: "SwiftConsistentHashing", targets: ["SwiftConsistentHashing"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.1.0"))
    ],
    targets: [
        .target(
            name: "SwiftConsistentHashing",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ]
        ),
        .testTarget(name: "SwiftConsistentHashingTests", dependencies: ["SwiftConsistentHashing"]),
    ]
)

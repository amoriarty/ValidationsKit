// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ValidationsKit",
    products: [
        .library(
            name: "ValidationsKit",
            targets: ["ValidationsKit"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ValidationsKit",
            dependencies: []),
        .testTarget(
            name: "ValidationsKitTests",
            dependencies: ["ValidationsKit"])
    ]
)

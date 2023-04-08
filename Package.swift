// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iNetBox",
    products: [
        .library(
            name: "iNetBox",
            targets: ["iNetBox"]),
    ],
    dependencies: [
        .package(url: "https://github.com/iShape-Swift/iSpace", from: "0.0.1")
    ],
    targets: [
        .target(
            name: "iNetBox",
            dependencies: ["iSpace"]),
        .testTarget(
            name: "iNetBoxTests",
            dependencies: ["iNetBox"]),
    ]
)

// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftBlob",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        .library(
            name: "SwiftBlob",
            targets: ["SwiftBlob"]),
    ],
    targets: [
        .target(name: "SwiftBlob")
    ]
)

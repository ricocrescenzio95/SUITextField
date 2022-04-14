// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUITextField",
    platforms: [.iOS(.v13), .macCatalyst(.v13)],
    products: [
        .library(
            name: "SwiftUITextField",
            targets: ["SwiftUITextField"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.9.0"
        )
    ],
    targets: [
        .target(
            name: "SwiftUITextField",
            dependencies: []
        ),
        .testTarget(
            name: "SUITextFieldTests",
            dependencies: [
                "SwiftUITextField",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            exclude: ["__Snapshots__"]
        ),
    ]
)

// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SUITextField",
    platforms: [.iOS(.v13), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SUITextField",
            targets: ["SUITextField"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SUITextField",
            dependencies: []),
        .testTarget(
            name: "SUITextFieldTests",
            dependencies: ["SUITextField"]),
    ]
)

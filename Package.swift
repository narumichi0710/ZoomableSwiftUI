// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZoomableSwiftUI",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "ZoomableSwiftUI",
            targets: ["ZoomableSwiftUI"]),
    ],
    targets: [
        .target(
            name: "ZoomableSwiftUI"),
        .testTarget(
            name: "ZoomableSwiftUITests",
            dependencies: ["ZoomableSwiftUI"]),
    ]
)

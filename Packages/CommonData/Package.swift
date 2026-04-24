// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CommonData",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "CommonData",
            targets: ["CommonData"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Resolver", from: "1.5.1"),
        .package(url: "https://github.com/kean/Pulse.git", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "CommonData",
            dependencies: [
                .product(name: "Resolver", package: "Resolver"),
                .product(name: "Pulse", package: "Pulse"),
                .product(name: "PulseProxy", package: "Pulse"),
                .product(name: "PulseUI", package: "Pulse")
            ]
        )
    ]
)

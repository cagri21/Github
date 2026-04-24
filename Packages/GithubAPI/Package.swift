// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "GithubAPI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "GithubAPI",
            targets: ["GithubAPI"]
        ),
        .library(
            name: "SearchAPI",
            targets: ["SearchAPI"]
        ),
        .library(
            name: "SearchDomain",
            targets: ["SearchDomain"]
        ),
        .library(
            name: "SearchData",
            targets: ["SearchData"]
        ),
        .library(
            name: "ProfileAPI",
            targets: ["ProfileAPI"]
        ),
        .library(
            name: "ProfileDomain",
            targets: ["ProfileDomain"]
        ),
        .library(
            name: "ProfileData",
            targets: ["ProfileData"]
        )
    ],
    dependencies: [
        .package(path: "../CommonData")
    ],
    targets: [
        .target(
            name: "GithubAPI",
            dependencies: [
                "ProfileAPI",
                "SearchAPI"
            ],
            path: "Sources/GithubAPI"
        ),
        .target(
            name: "SearchDomain",
            path: "API/SearchAPI/SearchDomain"
        ),
        .target(
            name: "SearchData",
            dependencies: [
                .product(name: "CommonData", package: "CommonData"),
                "SearchDomain"
            ],
            path: "API/SearchAPI/SearchData"
        ),
        .target(
            name: "SearchAPI",
            dependencies: [
                .product(name: "CommonData", package: "CommonData"),
                "SearchData",
                "SearchDomain"
            ],
            path: "API/SearchAPI",
            exclude: [
                "SearchData",
                "SearchDomain"
            ]
        ),
        .target(
            name: "ProfileDomain",
            path: "API/ProfileAPI/ProfileDomain"
        ),
        .target(
            name: "ProfileData",
            dependencies: [
                .product(name: "CommonData", package: "CommonData"),
                "ProfileDomain"
            ],
            path: "API/ProfileAPI/ProfileData"
        ),
        .target(
            name: "ProfileAPI",
            dependencies: [
                .product(name: "CommonData", package: "CommonData"),
                "ProfileData",
                "ProfileDomain"
            ],
            path: "API/ProfileAPI",
            exclude: [
                "ProfileData",
                "ProfileDomain"
            ]
        )
    ]
)

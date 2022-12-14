// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BeHonest",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Feed",
            targets: ["Feed"]),
        .library(
            name: "Settings",
            targets: ["Settings"]),
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]),
        .library(
            name: "Utility",
            targets: ["Utility"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            .upToNextMajor(from: "0.39.0")
        ),
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Feed",
            dependencies: [
                "Utility",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .target(
            name: "Settings",
            dependencies: [
                "Utility"
            ]),
        .target(
            name: "DesignSystem",
            dependencies: [
                "Utility"
            ]),
        .target(
            name: "Utility",
            dependencies: []),
        .testTarget(
            name: "BeHonestTests",
            dependencies: []),
    ]
)

// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BCSwiftEsplora",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "Esplora",
            targets: ["Esplora"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/WolfMcNally/WolfBase",
            from: "3.14.0"
        ),
        .package(
            url: "https://github.com/WolfMcNally/WolfAPI",
            from: "1.0.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Esplora",
            dependencies: ["WolfBase", "WolfAPI"]),
        .testTarget(
            name: "EsploraTests",
            dependencies: ["Esplora", "WolfBase", "WolfAPI"]),
    ]
)

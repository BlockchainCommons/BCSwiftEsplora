// swift-tools-version:5.9

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
        .package(url: "https://github.com/WolfMcNally/WolfBase", from: "6.0.0"),
        .package(url: "https://github.com/WolfMcNally/WolfAPI", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "Esplora",
            dependencies: ["WolfBase", "WolfAPI"]),
        .testTarget(
            name: "EsploraTests",
            dependencies: ["Esplora", "WolfBase", "WolfAPI"]),
    ]
)

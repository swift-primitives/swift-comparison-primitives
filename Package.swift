// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-comparison-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Comparison Primitives",
            targets: ["Comparison Primitives"]
        ),
        .library(
            name: "Comparison Primitives Core",
            targets: ["Comparison Primitives Core"]
        ),
        .library(
            name: "Comparison Primitives Standard Library Integration",
            targets: ["Comparison Primitives Standard Library Integration"]
        ),
        .library(
            name: "Comparison Primitives Test Support",
            targets: ["Comparison Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-equation-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-property-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-tagged-primitives.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Comparison Primitives",
            dependencies: [
                "Comparison Primitives Core",
                "Comparison Primitives Standard Library Integration"
            ]
        ),
        .target(
            name: "Comparison Primitives Core",
            dependencies: [
                .product(name: "Equation Primitives", package: "swift-equation-primitives"),
                .product(name: "Property Primitives", package: "swift-property-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),
        .target(
            name: "Comparison Primitives Standard Library Integration",
            dependencies: [
                "Comparison Primitives Core"
            ]
        ),
        .target(
            name: "Comparison Primitives Test Support",
            dependencies: [
                "Comparison Primitives",
                .product(name: "Tagged Primitives Test Support", package: "swift-tagged-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Comparison Primitives Tests",
            dependencies: [
                "Comparison Primitives",
                "Comparison Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}

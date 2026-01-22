// swift-tools-version: 6.2

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
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Comparison Primitives",
            dependencies: []
        ),
        .testTarget(
            name: "Comparison Primitives Tests",
            dependencies: ["Comparison Primitives"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableExperimentalFeature("Lifetimes"),
        .strictMemorySafety(),
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}

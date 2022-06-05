// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "FullScreenOverlay",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "FullScreenOverlay", targets: ["FullScreenOverlay", "Previews"])
    ],
    targets: [
        .target(name: "FullScreenOverlay", dependencies: []),
        .target(name: "Previews", dependencies: ["FullScreenOverlay"])
    ]
)

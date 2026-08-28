// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DoQuest",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "DoQuestCore", targets: ["DoQuestCore"])
    ],
    targets: [
        .target(name: "DoQuestCore"),
        .testTarget(name: "DoQuestCoreTests", dependencies: ["DoQuestCore"])
    ]
)


// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "swift-stakeholder",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "stakeholder", targets: ["stakeholder"])
    ],
    targets: [
        .executableTarget(name: "stakeholder"),
        .testTarget(name: "stakeholderTests", dependencies: ["stakeholder"])
    ]
)

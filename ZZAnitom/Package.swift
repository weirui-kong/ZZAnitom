// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ZZAnitom",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ZZAnitom",
            targets: ["ZZAnitom"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1")
    ],
    targets: [
        .target(
            name: "ZZAnitom",
            dependencies: ["SnapKit"], path: "Sources/ZZAnitom"
        ),
        .testTarget(
            name: "ZZAnitomTests",
            dependencies: ["ZZAnitom"]
        ),
    ]
)    

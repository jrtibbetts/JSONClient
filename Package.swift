// swift-tools-version:5.0
import PackageDescription

let pkg = Package(
    name: "JSONClient",

    platforms: [
        .iOS(.v10)
    ],

    products: [
        .library(
            name: "JSONClient",
            targets: ["JSONClient"]
        )
    ],

    dependencies: [
        .package(url: "https://github.com/jrtibbetts/Stylobate.git", .upToNextMajor(from: "0.27.0"))
    ],

    targets: [
        .target(
            name: "JSONClient",
            dependencies: ["Stylobate"],
            path: "Source"
        )
    ]
)


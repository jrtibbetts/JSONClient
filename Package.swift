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

    dependencies: [ ],

    targets: [
        .target(
            name: "JSONClient",
            path: "Source"
        )
    ]
)


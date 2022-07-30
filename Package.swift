// swift-tools-version:5.5
import PackageDescription

let pkg = Package(
    name: "JSONClient",

    platforms: [
        .iOS(.v14),
        .tvOS(.v14),
        .watchOS(.v7),
        .macOS(.v11)
    ],

    products: [
        .library(
            name: "JSONClient",
            targets: ["JSONClient"]
        )
    ],

    dependencies: [
        .package(url: "https://github.com/jrtibbetts/Stylobate.git",
                 .branch("main")),
        .package(url: "https://github.com/OAuthSwift/OAuthSwift.git",
                 .upToNextMajor(from: "2.2.0")),
        .package(url: "https://github.com/raxityo/OAuthSwiftAuthenticationServices",
                 .branch("master"))
    ],

    targets: [
        .target(name: "JSONClient",
                dependencies: ["Stylobate", "OAuthSwift", "OAuthSwiftAuthenticationServices"],
                path: "Source",
                exclude: ["Info.plist"]
        ),
        .testTarget(name: "JSONClientTests",
                    dependencies: ["JSONClient"],
                    path: "Tests",
                    exclude: ["Info.plist"],
                    resources: [.copy("SampleFoo.json")]
        )
    ]
)


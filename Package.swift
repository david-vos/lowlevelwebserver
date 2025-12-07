// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "lowlevelwebserver",
    targets: [
        .executableTarget(
            name: "lowlevelwebserver",
            path: "Sources"
        ),
    ]
)

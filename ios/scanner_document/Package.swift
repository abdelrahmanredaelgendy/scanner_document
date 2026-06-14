// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to
// build this package. Flutter's Swift Package Manager support requires 5.9+.
import PackageDescription

let package = Package(
    name: "scanner_document",
    // Required because the vendored WeScan resources include localized
    // (.lproj) strings; SPM needs a development localization.
    defaultLocalization: "en",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        // The library name (hyphenated) is what Flutter's generated package
        // links against; the target name (underscored) matches the plugin and
        // exposes the `DocumentScannerPlugin` class to the registrant.
        .library(name: "scanner-document", targets: ["scanner_document"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "scanner_document",
            dependencies: [],
            resources: [
                // The gallery icon used by the picker button.
                .process("Resources"),
                // Vendored WeScan assets and localizations.
                .process("WeScan/Resources")
            ]
        )
    ]
)

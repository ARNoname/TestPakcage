// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestPakcage",
    platforms: [
           .iOS(.v17)
       ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TestPakcage",
            targets: ["TestPakcage"]
        ),
    ],
    
    dependencies: [
        .package(url: "https://github.com/RevenueCat/purchases-ios", from: "5.51.1"),
        .package(url: "https://github.com/ARNoname/View_Ext.git", from: "1.2.4"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.2"),
        .package(url: "https://github.com/facebook/facebook-ios-sdk.git", from: "18.0.0"),
    ],
    
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TestPakcage",
            dependencies: [
                .product(name: "RevenueCat", package: "purchases-ios"),
                .product(name: "View_Ext", package: "View_Ext"),
                .product(name: "Lottie", package: "lottie-spm"),
                .product(name: "FacebookCore", package: "facebook-ios-sdk"),
            ],
        ),

    ]
)

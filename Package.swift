// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "MyBlog",
  products: [
    .executable(
      name: "MyBlog",
      targets: ["MyBlog"]
    )
  ],
  dependencies: [
    .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.6.0"),
    .package(name: "SplashPublishPlugin", url: "https://github.com/johnsundell/splashpublishplugin", from: "0.1.0")
  ],
  targets: [
    .target(
      name: "MyBlog",
      dependencies: [
        "Publish",
        "SplashPublishPlugin"
      ]
    )
  ]
)

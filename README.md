# RedApple
red

## Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding RedApple as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift` or the Package list in Xcode.

```swift
dependencies: [
    .package(url: "https://github.com/dominique-pe/RedApple.git", .upToNextMajor(from: "1.0.0"))
]
```

Normally you'll want to depend on the `RedApple` target:

```swift
.product(name: "RedApple", package: "RedApple")
```

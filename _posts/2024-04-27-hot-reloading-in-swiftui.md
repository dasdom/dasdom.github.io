---
layout: post
date: 2024-04-29 06:00
title: Hot Reloading In SwiftUI
description: Add real hot reloading to a SwiftUI project
tags: Xcode, iOS, Hot Reloading, SwiftUI, How-To
---

Previews in Xcode are kind of nice, when they work.
But for me they are often slow or stop working after a few minutes.

Fortunately for us, the amazing [John Holdsworth](https://johnholdsworth.com) wrote a packaged that adds hot reloading to SwiftUI projects.
Even better, it's suprisingly easy to add to your project.

## Method One: Swift Package

First, we need to add the following two Swift packages to the project:

- [HotReloading](https://github.com/johnno1962/HotReloading)
- [HotSwiftUI](https://github.com/johnno1962/HotSwiftUI)

When asked, only add the HotReloading package product to your target:

![](../../../assets/2024-04-29/hot_reloading_target.png)

Next add `-Xlinker -interposable` to 'Other Linker Flags' in the build settings of the target:

![](../../../assets/2024-04-29/other_linker_flags.png)

**In this method you need to remember to remove the hot reloadng package before you upload your app to App Store Connect.**

## Method Two: Injection III

You still need to add the [HotSwiftUI](https://github.com/johnno1962/HotSwiftUI) package to your project.
Again add `-Xlinker -interposable` to 'Other Linker Flags' in the build settings of the target:

![](../../../assets/2024-04-29/other_linker_flags.png)

Next load the latest release of the [Inject III app](https://github.com/johnno1962/InjectionIII/releases) and start it.

## Setup your view

In the view file you are currently working on, add the following import:

```swift
@_exported import HotSwiftUI
```

Next, erase the type of the root view using `.eraseToAnyView()`:

```swift
var body: some View {
  // Your SwiftUI code...
  .eraseToAnyView()
}
```

Finally add the following line to your view struct:

```swift
@ObserveInjection var redraw
```

Build and run your app on the Simulator, change some code and save the file.
The changes are magically compiled and injected into the running app:

![](../../../assets/2024-04-29/demo.gif)

## Conclusion

Hot reloading does not work all the time.
Sometimes you need to recompile using Xcode.
But most of the times it works suprisingly well.
Give it a try and see how amazing this is.

And if you like it and it helps in your daily work, consider [becomming a sponsor of the project on
GitHub](https://github.com/sponsors/johnno1962).

Thanks for reading!

---
layout: post
title: "Fun with iOS (3): A Simple View in Code"
date: 2018-09-10
categories: without ib
---

Before we start with the real app, we need to get a feeling about building user interfaces in code. Don't worry, it's easier than you might think.

In fact we already changed the user interface in code in the last post. We set the `backgroundColor` of the view in `viewDidLoad()`. As the name suggests, `viewDidLoad()` is called after the view did load but before it is rendered on screen. So, when building the user interface (UI) in code, are we supposed to put all the UI code into this method?

In documentation of `viewDidLoad()` we find this:

> This method is called after the view controller has loaded its view hierarchy into memory. This method is called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the `loadView()` method. You usually override this method to perform additional initialization on views that were loaded from nib files.

So this method is used to perform additional initialisation in case the user interface is loaded from nibs (i.e. when the UI is build in Interface Builder). This make sense because some properties cannot be set using Interface Builder.

But we are going to do all UI in code. We need to put our code somewhere else. The docs for `viewDidLoad()` already tell us where the code belongs: `loadView()`. In the docs for `loadView()` we find:

> You can override this method in order to create your views manually. If you choose to do so, assign the root view of your view hierarchy to the view property. [...] Your custom implementation of this method should not call super.

So we could create an instance of `UIView`, add subviews and assign it to the view property. But this way, we would put view code into the view controller. View code belongs into its own class. The view code should be separated from the view controller to make it reusable in other places of the app. We need a new class; a subclass of `UIView`.

In the project we created in the last post, add a new class using the Cocoa Touch Class template. Make it a subclass of `UIView` and call it `CounterView`.



If you have any feedback please ping be on [Twitter](https://twitter.com/dasdom).

---
layout: post
date: 2019-04-02 12:00
title: Testing The Presentation Of A View Controller
author: Dominik Hauser
description: It's quite easy to test if a view controller is presented on screen after some action. Here is how this works.
tags: TDD, iOS, Swift, Testing, Unit Tests, UIViewController
---

> I'm writing [a book about Test-Driven iOS Development](https://leanpub.com/tddfakebookforios) with Swift. It's not a traditional book, it's mainly only the code. If you are like me and seldom read blog posts but rather skim for the code, this book is for you.

Let's say we need to test if an action triggers the presentation of a view controller. The test looks like this:

```swift
func test_presentationOfViewController() {
  // Arrange
  let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
  // sut == system under test
  window.rootViewController = sut
  window.makeKeyAndVisible()
    
  // Act
  sut.showNext()
    
  // Assert
  XCTAssertTrue(sut.presentedViewController is DetailViewController)
}
```

First we have to set the view controller (`sut`) that presents the other view controller as the `rootViewController` of a window. Then we need to make the window the key window. This way, the view of the view controller is added to the view hierarchy. If we miss the step, no other view controller can be presented on top of that view controller.

Next the presentation is triggered. How this is done, depends on the code under test. For simplicity, I assume that there is a method `showNext()` that triggers the presentation.

In the end we assert that the presented view controller has the expected type. Depending on the presented view controller, we could also assert that an expected item (user, point of interest, tweet, etc) has been passed to it.

That's all. Straight forward. The tricky part is to remember to add the view controller under test as the root view controller to a window and make the window the key window.

Follow me on [Twitter](https://www.twitter.com/dasdom).

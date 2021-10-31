---
layout: post
date: 2019-03-16 12:00
title: Easy Unit Tests In iOS Development
author: Dominik Hauser
description: Starting with unit tests is not hard. Here are some easy tests you can add to your project right now.
tags: TDD, iOS, Swift, Testing, Unit Tests
---

Testing is hard. That's why it's not done enough in iOS development. When I ask other developers, many don't write unit tests at all. That's no good. Unit tests are an essential tool to build high quality iOS apps and allow disruptive refactoring without breaking functionalities.

The main advantages of writing unit tests are:
1. The code becomes refactorable.
2. Testable code usually is better code. So when you are "forced" to write code, your code automatically becomes better.
3. It's less likely to introduce regression into code with a good test coverage.
4. Writing the tests first often makes implementing a new feature easier because you intentionally make very small steps.
5. Tests are a living documentation. With living I mean, it's less likely that they get asynchronous to the actual code as it often happens to traditional documentation on some website.

OK, tests are good and important. Let's assume you are willing to start writing tests for your code. How do you start? The most important thing is to write the first test. So here are some easy tests you can introduce to you code right now. Let's get started.

## Test That A Property Was Set

Let's say we have a `User` struct with a `firstname` and a `lastname`:

```swift
struct User {
  var firstname: String = ""
  var lastname: String = ""
}
```

Now we need a property `name` that is `firstname` and `lastname` with space in between. 

We will add that feature using Test-Diven Development (TDD). In TDD you write the test before you add the code to be testet. It sounds strange but after you got used to it, this totally makes sense. We assume the project already has a test target. (If this is not the case, just add a test target.)

Now the test for the feature we are going to build:

```swift
import XCTest
@testable import MyApp

class PropertyTests : XCTestCase {
  
  var sut: User!
  
  override func setUp() {
    sut = User()
  }
  
  override func tearDown() {
    sut = nil
  }
  
  func test_name_property() {
    // Arrange

    // Act
    sut.firstname = "Foo"
    sut.lastname = "Bar"
    
    // Assert
    XCTAssertEqual(sut.name, "Foo Bar")
  }
}
```

Try running the test with the shortcut ⌘U. The test does not compile because `User` doesn't have a property named `name`. A not compiling test is a failing test. Let's add enough code to make it compile.

```swift
struct User {
  var firstname: String = ""
  var lastname: String = ""
  var name: String = ""
}
```

Again run the test with ⌘U. Now the test compiles but if fails. This is a good sign because we haven't implemented the code we like to test. If the test would pass before we have implemented the feature, probably the test would pass all the time and would therefore be useless.

When we change the `User` struct to the following the test passes:

```swift
struct User {
  var firstname: String = "" {
    didSet {
      updateName(firstname: firstname,
                 lastname: lastname)
    }
  }
  var lastname: String = "" {
    didSet {
      updateName(firstname: firstname,
                 lastname: lastname)
    }
  }
  var name: String = ""
  
  private mutating func updateName(firstname: String, lastname: String) {
    
    name = "\(firstname) \(lastname)"
  }
}
```

If you run the test again, you'll see that it now passes. Awesome! We just used Test-Driven Development to add a feature to the `User` struct.

If you want to learn more about TDD and how to test many different scenarios in iOS development, I'm writing a book about that. It's still im progress, but you can already get it at [leanpub](https://leanpub.com/tddfakebookforios).

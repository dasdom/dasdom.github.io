---
layout: post
date: 2021-07-22 12:00
title: Test The Publisher Of A @Published Property
description: How to test the publisher of a @Published property.
tags: Unit-Tests, TDD, Combine, Published
---

[John Sundell](https://twitter.com/johnsundell) wrote a [blog post](https://www.swiftbysundell.com/articles/unit-testing-combine-based-swift-code/) about how to test Combine-based code.
In the article he shows how to write unit tests for a publisher that tokenises a string.
Great article as always and you should read it.

This blog post here is just a reminder for me how to change Johns `XCTestCase` extension to test the publisher of a `@Published` property.
Without further ado here is the extension:

```swift
extension XCTestCase {
  func _awaitPublishedChange<T: Publisher>(
    _ publisher: T,
    changeAction: () -> Void = {},
    timeout: TimeInterval = 1,
    file: StaticString = #file,
    line: UInt = #line
  ) throws -> T.Output where T.Failure == Never {

    var result: Result<T.Output, Error>?
    let expectation = self.expectation(description: "Awaiting publisher")
  
    let cancellable = publisher
      .dropFirst()
      .sink(receiveValue: { value in
        result = .success(value)
        expectation.fulfill()
      })
    
    changeAction()
    waitForExpectations(timeout: timeout)
    cancellable.cancel()
  
    let unwrappedResult = try XCTUnwrap(
      result,
      "Awaited publisher did not produce any output",
      file: file,
      line: line
    )
  
    return try unwrappedResult.get()
  }
}
```

And this is how to use it:

```swift
func test_addEvent_shouldPublishChangedEvents() throws {
  let fileManagerMock = FileManagerProtocolMock()
  fileManagerMock.eventsURLReturnValue = 
    documentsURL(for: dummyEventsFilename)
  let sut = EventStore(fileManager: fileManagerMock)
  sut.events = [Event(name: "Bla", 
                      date: Date(timeIntervalSinceNow: -1000))]
  
  let events = try _awaitPublishedChange(
    sut.$events, 
    changeAction: { 
      sut.add(Event(name: "Foo", date: Date()))
    })
  
  XCTAssertEqual(events.count, 2)
}
```

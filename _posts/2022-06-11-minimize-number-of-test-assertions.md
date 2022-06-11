---
layout: post
date: 2022-06-11 08:00
title: Minimize the number of test assertions
description: Why you should minimize the number of test assertions in your Unit Tests.
tags: Unit-Tests, XCTest, Assertions, TDD
---

Recently I wrote a [tweet](https://twitter.com/dasdom/status/1534208496018894849) about demo code shown by an Apple engineer in a WWDC session.

> Demo code doesn’t need to be good. If you are wondering, this is not how to write unit tests when you are not demonstrating. Try to only have one assertion in a test method.

I got several answers that it's not practical to write a test for each small little detail one wants
to test and that it's better to test several things in one test if possible.
I totally disagree.
It might be OK to have several asserts in one test but this should be an exception.
Especially in the case of the test code from the WWDC session, I would rather have several tests.

This is the code that was shown in the video:

```
func testExtractEventCount () throws {
    
    let providerClass = ServerBackedEventProvider.self 

    // Simple cases
    XCTAssertEqual(providerClass.extractEventCount(from: "0 records"), 0)
    XCTAssertEqual(providerClass.extractEventCount(from: "1 record"), 1)
    XCTAssertEqual(providerClass.extractEventCount(from: " 1 record(s)"), 1)
    XCTAssertEqual(providerClass.extractEventCount(from: "25 records"), 25)
    XCTAssertEqual(providerClass.extractEventCount(from:"50 records"), 50)
    
    // Cases we expect parsing to return nil
    XCTAssertNil(providerClass.extractEventCount(from: "NaN records") )
    XCTAssertNil(providerClass.extractEventCount(from: ""))
    XCTAssertNil(providerClass.extractEventCount(from: "jUnKdAtA"))
}
```

In the demo code is a bug and therefore this test fails in the line extracting from "0 records" and
from "50 records".
With the information from this test, the engineer can fix the bug quickly.

But if this test would fail on Xcode Cloud, the engineer would only see the following:

```
testExtractEventCount(): XCTAssertEqual failed: ("nil") is not equal to ("Optional(0)")
```

Not really helpful in my opinion.
Critical information is missing:

- What was tested?
- What was the precondition?
- What did we expect?

I would split the test assertions into several tests.
Testing for the extraction from "0 records" would then look like this:

```
func test_extractEventCount_whenInputIs0Records_shouldExtractO() throws {
    // given
    let sut = SeverBackedEventProvider.self

    // when
    let result = sut.extractEventCount(from: "0 records")

    // then
    XCTAssertEqual(result, 0)
}
```

In case of a failure of this test we would see in the test result the following:

```
text_extractEventCount_whenInputIs0Records_shouldExtractO(): XCTAssertEqual failed: ("nil") is not
equal to ("Optional(0)")
```

Without looking at the test code, I already know what exactly failed.
Tests should help my future self and my coworkers to find the reason for the failure as quick as
possible.
This is the main feature a test should have.
Personally I find the failure message of the second test way better and looking at the test I do
better understand its purpose and why it was written.

What do you think?
Which of these tests is better?
Let me know on [Twitter](https://twitter.com/dasdom).

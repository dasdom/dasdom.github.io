---
layout: post
title: Using Guard In Unit Tests
date: 2015-07-29 14:30:33.000000000 +02:00
type: post
published: true
status: publish
categories:
- Tips
tags:
- guard
- nil
- Swift 2.0
- Unit Test
---
Here is the problem: Sometimes you want to test an element that could be
nil. For example, I recently wanted to test if a view controller has a
right bar button item with a given target. This could be done like this:

{% highlight swift %}
func testViewController_HasAddButtonInNavigationBar() {
  let _ = viewController.view
  
  XCTAssertNotNil(viewController.navigationController)
  XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
  let addBarButton = viewController.navigationItem.rightBarButtonItem!
  let target = addBarButton.target
  XCTAssertEqual(target as! TimerTableViewController, viewController, "The view controller should be the target of the right bar button")
}
{% endhighlight %}

The problem with this code is, that if there is no right bar button item
the test execution crashes. Let's make it kind of better:

{% highlight swift %}
func testViewController_HasAddButtonInNavigationBar() {
  let _ = viewController.view
  
  if let _ = viewController.navigationController {
    XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    if let addBarButton = viewController.navigationItem.rightBarButtonItem {
      let target = addBarButton.target
      XCTAssertEqual(target as! TimerTableViewController, viewController, "The view controller should be the target of the right bar button")
    }
  } else {
    XCTAssertFalse(true)
  }
}
{% endhighlight %}

Uhhg... Now it doesn't crash but it's really ugly. Here comes the rescue
with guard:
<!--more-->

{% highlight swift %}
func testViewController_HasAddButtonInNavigationBar() {
  let _ = viewController.view
  guard let _ = viewController.navigationController else { XCTFail("There should be a navigation controller"); return }
  guard let addBarButton = viewController.navigationItem.rightBarButtonItem else {
    XCTFail("The navigation bar should have a button on the right")
    return
  }
  guard let target = addBarButton.target else { XCTFail("The bar button should have a target"); return }
  XCTAssertEqual(target as! TimerTableViewController, viewController, "The view controller should be the target of the right bar button")  
}
{% endhighlight %}

This is beautiful! Thanks Swift 2.0 and thanks guard! If you enjoyed
this post, then make sure you subscribe to my
[feed](http://swiftandpainless.com/feed).

**Update:** As suggested in the comments by Stephan Michels I changed
`XCTAssertFalse()` to `XCTFail()`.
Thanks Stephan!

**Update 2:** David Owens II [wrote on
Twitter](https://twitter.com/owensd/status/627946978882682880) that you
can get the same behavior without guard when adding 
`set.continueAfterFailure = false` to the `setUp()`. Thanks
David!

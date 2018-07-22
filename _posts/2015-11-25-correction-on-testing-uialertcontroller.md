---
layout: post
title: Correction On Testing UIAlertController
date: 2015-11-25 21:46:21.000000000 +01:00
type: post
published: true
status: publish
categories:
- TDD
tags:
- Test
- UIAlertAction
- UIAlertController
- Unit Test
---
Two month ago I published a post about [How To Test
UIAlertController](http://swiftandpainless.com/how-to-test-uialertcontroller-in-swift/).
A reader found out that the test doesn't work as I expected:

> [@dasdom](https://twitter.com/dasdom) Your tests work, but ur
> convienience init in MockUIAction is never triggered - u can't
> override convienience inits. Seems an ios bug
>
> — Larhythimx (@Larhythmix) [25. November
> 2015](https://twitter.com/Larhythmix/status/669456137041915905)

Larhythimx is totally right. The init method of the mock is never
called. The reason why I didn't see this when I wrote the test is, that
the handler is actually called. It looks like the real `UIAlertAction` does
use handler as the hidden internal variable to store the handler closure
of the action. This is fragil and Larhythimx mentions in another tweet
that the handler is nil in test he tries to write.
<!--more-->

So as the golden way (i.e. write tests without changing the
implementation) does not work here, let's go for silver.

First we add a class method to `UIAlertAction` that
creates actions. Add the following extension in `ViewController.swift`
:

{% highlight swift %}
extension UIAlertAction {
  class func makeActionWithTitle(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
    return UIAlertAction(title: title, style: style, handler: handler)
  }
}
{% endhighlight %}

In the `MockAlertAction` add
this override:

{% highlight swift %}
override class func makeActionWithTitle(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?) -> MockAlertAction {
  return MockAlertAction(title: title, style: style, handler: handler)
}
{% endhighlight %}

In the implementation code we can now use the class methods to create
the alert actions:

{% highlight swift %}
let okAction = Action.makeActionWithTitle("OK", style: .Default) { (action) -> Void in
    self.actionString = "OK"
}
let cancelAction = Action.makeActionWithTitle("Cancel", style: .Default) { (action) -> Void in
    self.actionString = "Cancel"
}
alertViewController.addAction(cancelAction)
{% endhighlight %}

To make sure we do really test, what we think we do test, rename the
`handler` property in `MockAlertAction` to
mockHandler:

{% highlight swift %}
var mockHandler: Handler?
{% endhighlight %}

In addition we add tests for the mock title of the actions. The test for
the cancel action then looks like this:

{% highlight swift %}
func testAlert_FirstActionStoresCancel() {
  sut.Action = MockAlertAction.self
  
  sut.showAlert(UIButton())
  
  let alertController = sut.presentedViewController as! UIAlertController
  let action = alertController.actions.first as! MockAlertAction
  action.mockHandler!(action)
  
  XCTAssertEqual(sut.actionString, "Cancel")
  XCTAssertEqual(action.mockTitle, "Cancel")
}
{% endhighlight %}

This test would have failed in the previous version because as the init
method got never called the mock title did not get set.

You can find the corrected version on
[github](https://github.com/dasdom/TestingAlertExperiment).

Thanks again Larhythimx for the tweet!

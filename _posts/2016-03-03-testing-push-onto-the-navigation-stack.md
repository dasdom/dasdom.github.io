---
layout: post
title: Testing Push Onto The Navigation Stack
date: 2016-03-03 22:23:58.000000000 +01:00
type: post
published: true
status: publish
categories:
- Swift
- TDD
tags:
- Push
- pushViewController
- Swift
- TDD
- Testing
- UINavigationController
- Unit Test
---
Last month [my book about Test-Driven Development with
Swift](https://www.packtpub.com/application-development/test-driven-ios-development-swift)
finally got published. In this and some of the next blog posts I will
present some things I learned while I wrote it.

In this post I will show a nice way to test if a view controller got
pushed onto the navigation stack as a result of an event.

Let's say we have button on a view controller. When the user taps the
button, a detail view controller should be pushed onto the navigation
stack. How can we test this?

Easy! We will use a mock for the navigation controller. The mock looks
like this:

{% highlight swift %}
class MockNavigationController: UINavigationController {
  
  var pushedViewController: UIViewController?
  
  override func pushViewController(viewController: UIViewController, animated: Bool) {
    pushedViewController = viewController
    super.pushViewController(viewController, animated: true)
  }
}
{% endhighlight %}
<!--more-->

To be precise, this is a partial mock. It is a subclass of `UINavigationController`
and it overrides only one method of the superclass. This mock registers
when `pushViewController(_:animated:)`
is called and stores the view controller that got passed into the method
as the first parameter.

The test would look like this:

{% highlight swift %}
func testTappingPushButton_PushesDetailViewControllerOntoStack() {
  let viewController = ViewController()
  let navigationController = MockNavigationController(rootViewController: viewController)
  UIApplication.sharedApplication().keyWindow?.rootViewController = navigationController
  
  guard let view = viewController.view as? View else { XCTFail(); return }
  view.button.sendActionsForControlEvents(.TouchUpInside)
  
  XCTAssertTrue(navigationController.pushedViewController is DetailViewController)
}
{% endhighlight %}

First, we arrange the view controller to be the `rootViewController`
of an instance of our navigation controller mock. Then we set the
navigation controller to be the `rootViewController`
of the `keyWindow` of the `UIApplication`
singleton. This is needed because to be able to push a view controller
onto the navigation stack, the view of the view controller has to be in
the view hierarchy.

Next, we get the button and send it all actions for the control events
`.TouchUpInside`. Finally we assert that the pushed view controller is of type 
`DetailViewController`.

You can find the code on
[github](https://github.com/dasdom/TestingNavigationDemo).

You can find a lot more about how to test real world examples in [my
book](https://www.packtpub.com/application-development/test-driven-ios-development-swift).
Please don't forget to let me know what you think about the book when
you read it.

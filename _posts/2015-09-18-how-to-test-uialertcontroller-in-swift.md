---
layout: post
title: How To Test UIAlertController in Swift
date: 2015-09-18 19:33:19.000000000 +02:00
type: post
published: true
status: publish
categories:
- HowTo
- TDD
tags:
- Mocking
- Swift
- Swizzling
- Testing
- UIAlertController
---
**Update Nov. 25th 2015: This kind of testing does not work. You can
find the correct version
[here](http://swiftandpainless.com/correction-on-testing-uialertcontroller/).**

Recently I read a [blog
post](http://qualitycoding.org/testing-uialertcontrollers/) about
testing `UIAlertController` in
Objective-C using control swizzling. Posts like this always trigger me
to find a way to test the same without the swizzling. I know that
swizzling is a powerful tool developers should have access to in their
developer tool box. But I personally avoid it when ever I can. In fact
only one app I worked on in the last six years used swizzling. And today
I believe we could have implemented it without it.

So how to test `UIAlertController` in
Swift without the swizzling?
<!--more-->

Let's start with the code we want to test. I have added a button to the
storyboard. (I'm using a storyboard here to make this post accessible to
people who don't wan't to do their UI in code.) When the button is
tapped an alert is shown with a title, a message and two buttons, OK and
Cancel. Here is the code:

{% highlight swift %}
import UIKit

class ViewController: UIViewController {
  
  var actionString: String?
  
  @IBAction func showAlert(sender: UIButton) {
    let alertViewController = UIAlertController(title: "Test Title", message: "Message", preferredStyle: .Alert)
    
    let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
      self.actionString = "OK"
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
      self.actionString = "Cancel"
    }
    
    alertViewController.addAction(cancelAction)
    alertViewController.addAction(okAction)
    
    presentViewController(alertViewController, animated: true, completion: nil)
  }
}
{% endhighlight %}

Note that the alert actions don't do anything interesting in this
example. They just represent a change a unit test could verify.

Let's start with an easy test: Test the title and the message of the
alert controller.

The setup code for the tests looks like this:

{% highlight swift %}
import XCTest
@testable import TestingAlertExperiment

class TestingAlertExperimentTests: XCTestCase {
  
  var sut: ViewController!
  
  override func setUp() {
    super.setUp()
  
    sut = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
    
    UIApplication.sharedApplication().keyWindow?.rootViewController = sut
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
}
{% endhighlight %}

We need to set the sut to the rootViewController otherwise the view
controller can't present the alert view controller.

Add the following test for the title of a UIAlertController:

{% highlight swift %}
func testAlert_HasTitle() {
  sut.showAlert(UIButton())
    
  XCTAssertTrue(sut.presentedViewController is UIAlertController)
  XCTAssertEqual(sut.presentedViewController?.title, "Test Title")
}
{% endhighlight %}

That was easy. Now let's test the cancel button of the
UIAlertController. The problem: The handler block of the alert action
can't be accessed. Therefore we need a mock alert action to store the
handler to be able to call it in the test to see if the action does what
we expect. Add the following mock class within the test case:

{% highlight swift %}
class MockAlertAction : UIAlertAction {
  
  typealias Handler = ((UIAlertAction) -> Void)
  var handler: Handler?
  var mockTitle: String?
  var mockStyle: UIAlertActionStyle
  
  convenience init(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?) {
    self.init()
    
    mockTitle = title
    mockStyle = style
    self.handler = handler
  }
  
  override init() {
    mockStyle = .Default
    
    super.init()
  }
}
{% endhighlight %}

The primary job of the mock class is to capture the handler for later
use. Now we need to inject the mock class into the implementation code.
Replace the view controller code with the following:

{% highlight swift %}
import UIKit

class ViewController: UIViewController {
  
  var Action = UIAlertAction.self
  var actionString: String?
  
  @IBAction func showAlert(sender: UIButton) {
    let alertViewController = UIAlertController(title: "Test Title", message: "Message", preferredStyle: .Alert)
    
    let okAction = Action.init(title: "OK", style: .Default) { (action) -> Void in
      self.actionString = "OK"
    }
    
    let cancelAction = Action.init(title: "Cancel", style: .Cancel) { (action) -> Void in
      self.actionString = "Cancel"
    }
    
    alertViewController.addAction(cancelAction)
    alertViewController.addAction(okAction)
    
    presentViewController(alertViewController, animated: true, completion: nil)
  }
}
{% endhighlight %}

We have added a class variable `Action` which is set
to `UIAlertAction.self`.
This variable is used when we initialize the alert actions. This enables
us to overwrite it in the test. Let's do it:

{% highlight swift %}
func testAlert_FirstActionStoresCancel() {
  sut.Action = MockAlertAction.self
  
  sut.showAlert(UIButton())
  let alertController = sut.presentedViewController as! UIAlertController
  let action = alertController.actions.first as! MockAlertAction
  action.handler!(action)
  
  XCTAssertEqual(sut.actionString, "Cancel")
}
{% endhighlight %}

First we inject the mock alert action. Then we call the code that
presents the alert view controller. We get the cancel action from the
presented view controller and call the captured handler. The last step
is to assert that the action actually does what we expect.

That's it. A very easy way to test an `UIAlertViewController` without the
swizzling.

**Update Nov. 25th 2015: This kind of testing does not work. You can
find the correct version
[here](http://swiftandpainless.com/correction-on-testing-uialertcontroller/).**

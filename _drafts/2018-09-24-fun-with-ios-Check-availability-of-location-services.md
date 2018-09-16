---
layout: post
date: 2018-09-11
categories: without ib
title: "Fun With iOS VI: Check Availability of Location Services"
---

This post is part of a series in which we build a geofence App.

To be able to write tests, we need a test target. If you don't have a test target already, you can add one in the target list:

{:refdef: style="text-align: center;"}
![Login screen]({{ "/assets/2018-09-24/01.png" | absolute_url }})
{:refdef}

Chose the iOS Unit Testing Bundle. Per default, Xcode adds a test case to the test target. A test case is a class containing several different tests for one specific aspect of the app. The test case added by Xcode is not really useful because it has a strange name; the name of the target with a postfix 'Tests'. If we'd take that name serious, we would put into that test case all tests for the app. That would be to messy. We need a new test case.

Select the test case and add a new file. Chose the Unit Test Case Class template.

{:refdef: style="text-align: center;"}
![Login screen]({{ "/assets/2018-09-24/02.png" | absolute_url }})
{:refdef}

I call the new test case `AddGeofenceTests`. I'm not sure which tests will go here, so when the name doesn't match the contents anymore, we can change the name. For now it's enough to get us started.

The template provided by Xcode already has two tests. We don't need those, so they can be deleted. 

### Availability of location services
But what do we need to test? [In the documentation of the Core Location framework](https://developer.apple.com/documentation/corelocation/determining_the_availability_of_location_services) there is this sentence:

> Before using any specific location service, check the availability of that service using the methods of your CLLocationManager object.

And there is one method that seems to fit our use case:

> **`locationServicesEnabled()`**   
> Tells whether you can get the geographic coordinate for the user's current location.

So we add the test method:

{% highlight swift %}
func test_viewLoading_calls_locationServicesEnabled() {
    
}
{% endhighlight %}

Test methods in XCTest (the testing framework we are using here) need to start with the word test. Otherwise the test runner can't find them. The rest of the name should describe what the test is doing. You should be able to guess what the test is doing several months after you have written it. In test methods I prefer snake_case but feel free to chose a naming scheme that better fits you taste.

This is already a valid test even though it has no body. Run the tests (**Product > Test**) and see what happens.

{:refdef: style="text-align: center;"}
![Login screen]({{ "/assets/2018-09-24/03.png" | absolute_url }})
{:refdef}

After the tests have finished, Xcode shows a checkmark next to the test method. This means the test passed. So an empty test is always green (i.e. it passes). Keep that in mind. That's important because if you forget to run the tests before you have written any code, you cannot be sure that the test actually tests something.

### Mocking
To figure out whether `locationServicesEnabled()` is called we need to inject a placeholder object into the production code that is able to register calls to this method. This process is called *mocking*. And it works like this:

- Add code that allows to change dependencies in the code.
- Create a mock object that can be injected into the code and inject it.
- Call the method you'd like to test.
- Assert that the method you expected to be called is actually called.

Don't worry, this sounds more complicated than it is. So let's see it in action.

First we need a class that enables the user to add a geofence. For now we'll put that code into the view controller that shows the user interface. Later on we might find a better place for that code. 

In Test-Driven Development you always start with a failing test (and compilation errors count as a failing test). In the test method `test_viewLoading_calls_locationServicesEnabled()` add the following code:

{% highlight swift %}
let sut = AddGeofenceViewController()
{% endhighlight %}

The compiler complains 
> Use of unresolved identifier 'AddGeofenceViewController'

Yeah sure, there is no class with that name in the project. So we have our first failing test. Let's make the test pass. To achieve that, we need to add a class with that name. Add a subclass of `UIViewController` with the name `AddGeofenceViewController` to the main target. Remove the template code within the class such that it looks like this:

{% highlight swift %}
import UIKit

class AddGeofenceViewController: UIViewController {

}
{% endhighlight %}

Head back to the test and import the main target into the test case:

{% highlight swift %}
import Fency
{% endhighlight %}

Uh, it still does not compile. The reason is that the default access level in Swift is internal. This means our new class is only accessible from within the main target. To make it accessible from the test target, add the keyword `@testable` to the import statement:

{% highlight swift %}
@testable import Fency
{% endhighlight %}

This is a neat feature of Swift. But you should only use it in tests. And unfortunately it does not import private classes, properties and methods. Those aren't testable in Swift.

Following the bullet points, we first need to add code that allows to change dependencies in the code. Our class will use `CLLocationManager` to figure out if the device is able to locate itself using location services. In the test, we want to inject into the code an object controlled by the tests. This object will register when `locationServicesEnabled()` is called.
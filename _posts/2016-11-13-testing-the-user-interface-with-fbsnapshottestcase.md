---
layout: post
title: Testing the User Interface with FBSnapshotTestCase
type: post
---
Sometimes you need to add automatic tests for the UI of your app. There are several different approaches to achieve this.

In the test you could get the elements of the screen and assert if all the frames are as you expect. Depending on the UI you want to test, this can be a lot of work.

Or you could use UI tests provided by Xcode. But those are extremely slow and in my experience sometimes they just stop working.

There is a better alternative. Facebook has an open source component called `FBSnapshotTestCase`. This class allows you create snapshot tests. A snapshot test compares the UI of a view with a snapshot of how the view should look like. Let's see how this works.
<!--more-->

The UI I would like to test looks like this:

![]({{ site.baseurl }}/assets/20161113_163421_login_ui.png)

There are two stack views with a label, a button and two text fields.

# Installing FBSnapshotTestCase using Carthage

I'm a Carthage person. So I will show you how to use Carthage to install `FBSnapshotTestCase` in the test target and use it to add a snapshot test for a simple login screen.

Create a Cartfile that looks like this:

{% highlight bash %}
github "facebook/ios-snapshot-test-case"
{% endhighlight %}

Then ask Carthage to create the dynamic framework with the command

{% highlight bash %}
carthage update --platform iOS
{% endhighlight %}

Carthage will fetch the source code from github and build the framework. When Carthage is finished, drag the framework from the `Carthage/Bild/iOS` folder to **Link Binary with Libraries** build phase of you test target:

![]({{ site.baseurl }}/assets/20161113_163421_link_binaries.png)

Next, add a new run script build phase to the test target. Put in the command

{% highlight bash %}
/usr/local/bin/carthage copy-frameworks
{% endhighlight %}

and add the Input File `$(SRCROOT)/Carthage/Build/iOS/FBSnapshotTestCase.framework`. In Xcode it should look like this:

![]({{ site.baseurl }}/assets/20161113_163421_run_script.png)

# Configure FBSnapshotTestCase

Next you need to configure the directories where the snapshots should be put. You can also tell `FBSnapshotTestCase` to create a diff image whenever a snapshot test fails. This means, when a test fails, an image is created that shows the difference between the expected UI and the UI that made the test fail. That way you can figure out what changed in the UI.

Open the scheme you use of the test and add the following environment variables:

{% highlight bash %}
FB_REFERENCE_IMAGE_DIR: $(SOURCE_ROOT)/$(PROJECT_NAME)Tests/FailureDiffs
FB_REFERENCE_IMAGE_DIR: $(SOURCE_ROOT)/$(PROJECT_NAME)Tests/ReferenceImages
{% endhighlight %}

In Xcode this looks like this:

![]({{ site.baseurl }}/assets/20161113_image_directories.png)

# Create the snapshot

To create a snapshot test, add a subclass of `FBSnapshotTestCase` to your test target and add the following import statements:

{% highlight swift %}
import FBSnapshotTestCase
@testable import SnapshotTestDemo
{% endhighlight %}

Next, add the test method:

{% highlight swift %}
func test_LoginViewSnapshot() {
  let storyboard = UIStoryboard(name: "Main", bundle: nil)
  let sut = storyboard.instantiateInitialViewController() as! ViewController
  _ = sut.view
  
  recordMode = true
  
  FBSnapshotVerifyView(sut.view)
}
{% endhighlight %}

The first two lines create an instance of the view controller you want to test. The line `_ = sut.view` triggers the loading of the view. This is necessary because otherwise the view is nil in the test. The line `recoredMode = true` tells the `FBSnapshotTestCase` that it should create the reference snapshot. With `FBSnapshotVerifyView(sut.view)` the reference snapshot is compared with the current UI of the view.

Run the test. The test will fail because `FBSnapshotVerifyView()` doesn't find a reference snapshot to compare the view with. Open the directory of the test target in Finder. There is now a directory `ReferenceImages_64`. In this directory you can find all the snapshots recored in record mode.

Now remove the line `recordMode = true` from the test and run the test again. The test succeeds. Nice! From now on, whenever the UI of the login screen changes you will be notified by a failing test.

# Diff images

But how do we know that the snapshot test really works? Easy, let's change the UI and see what happens. Change something in the UI. In the example UI the spacing of the inner stack view holding the text field and the button is 20 points. I change it to 21 and run the test again. 

The test fails and there is a new directory with the name `FailureDiffs` in the directory of the test target. In this new directory you can find all diff images of the failing tests. In my case, the diff image looks like this:

![]({{ site.baseurl }}/assets/20161113_diff_test_LoginViewSnapshot.png)

Awesome! With this image it should be easy to find the change in the UI that made the test fail.

If you wan't to learn more about testing (especially Test-Driven iOS Development) I have written [a book about it](http://swiftandpainless.com/book/). The feedback for the first edition was quite good and many readers said that it helped them to get their head around test-driven iOS development.

Have fun and test all your UIs!

---
layout: post
title: "Fun with iOS (2): Removing the Storyboard"
date: 2018-09-17
categories: without ib
---

When you create a new project in Xcode, it comes with a storyboard. The storyboard handles a few things necessary to bring the initial view controller on screen. In the view debugger a plain Single View Application looks like this:

{:refdef: style="text-align: center;"}
![]({{ "/assets/2018-09-17/01.png" | absolute_url }})
{:refdef}

So there is a window, a view controller and a view. The window contains the view controller and the view controller contains the view. So the storyboard (or the code that loads it) is responsible to create a window and set the root view controller. But why is there a window at all? Couldn't we just put a view controller on screen?

The answer can be found [in the documentation](https://developer.apple.com/library/archive/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/TheAppLifeCycle/TheAppLifeCycle.html).

> In addition to hosting views, windows work with the UIApplication object to deliver events to your views and view controllers.

This means, when we want to build our app without using Interface Builder, we need to provide a window and set the root view controller. Let's do exactly that. Create a new project using the Single View Application template.  I call the project SimpleApp but you sure find a better name. :)

First, remove the storyboard in the project navigator. Then remove the name of the storyboard in the General tab of the target settings.

{:refdef: style="text-align: center;"}
![]({{ "/assets/2018-09-17/02.png" | absolute_url }})
{:refdef}

We have now completely removed the storyboard from the project. When we build and run and inspect the app again in the view debugger nothing is shown. There is nothing to see here. 

So we need a window. In `AppDelegate` there is already a property for the window:

{% highlight swift %}
var window: UIWindow?
{% endhighlight %}
  
But it is not set to anything. Before we removed the storyboard, it was set when the storyboard was loaded. Initialising the window is easy. `UIWindow` is a subclass of `UIView`. This means it can be initialised like this:

{% highlight swift %}
var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
{% endhighlight %}

Next we need to set the root view controller. The perfect place to do this is `application(_:didFinishLaunchingWithOptions:)`:

{% highlight swift %}
func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: 
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                     
    window?.rootViewController = ViewController()
    window?.makeKeyAndVisible()
    
    return true
}
{% endhighlight %}

There is an additional line: `window?.makeKeyAndVisible()`. With this call we tell UIKit that this window has to be made visible and that it is the key window. The key window of an application receives keyboard and other non-touch events. 

We are nearly finished. There is only one thing left to do. If we build and run the app in the current state again the view debugger shows that the view of the view controller is transparent. 

{:refdef: style="text-align: center;"}
![]({{ "/assets/2018-09-17/03.png" | absolute_url }})
{:refdef}

The reason is that `.clear` is the default `backgroundColor` for `UIView`s. But when we add a view controller to a storyboard, the background color of the view in the view controller is set to `.white`.

As we have removed the storyboard from the project, we need to set it ourselves. For now a good place for that is `viewDidLoad()` in the view controller:

{% highlight swift %}
override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.white
}   
{% endhighlight %}

Done! We have successfully removed the storyboard from the project. It's not that hard, isn't it? 

- Remove the Storyboard
- Delete a string in the settings
- Add four lines of code

And we are good to go.

If you have any feedback please ping be on [Twitter](https://twitter.com/dasdom).

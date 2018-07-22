---
layout: post
title: Using DDHTweaks To Find Perfect Values
type: post
---
Sometimes you may wish you could tweak some values of your app (colors, font sizes, text) while you test it in the field. Or you would like to enable a feature to test it but don't like to show that feature to your beta testers yet.

With my framework [DDHTweaks](https://github.com/dasdom/DDHTweaks) you can do exactly this. You just need to add a bit of code to be able to change some values while the app runs.
<!--more-->
Here is an easy example. Let's say you have a login screen and you want to animate the appearance of the textfields and the button when the screen is presented. If you have done this before, you may remember that finding the right values for the animation takes some time because you have to build and run after each change. Some people even started to tweak animations in Playgrounds because it's faster testing on the simulator.

With DDHTweaks you can find the right values even faster.

*Note: In this example I'll use storyboards because this is the way most people build their apps. Normally I don't use storyboards. ;)*

The screen we would like to animate looks like this:

![]({{ site.baseurl }}/assets/20161204_2213_tweaks_demo_screen.png)

The layout of the elements is done using Auto Layout. Therefore to be able to animate thier appearance, we need references to all the layout constraints:

{% highlight swift %}
@IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
@IBOutlet weak var labelUsernameConstraint: NSLayoutConstraint!
@IBOutlet weak var usernamePasswordConstraint: NSLayoutConstraint!
@IBOutlet weak var passwordButtonConstraint: NSLayoutConstraint!
{% endhighlight %}

Each of these constraints defines the vertical distance to the next element in the layout. One way to animate the appearance of these elements could look like this:

{% highlight swift %}
override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
  
  labelTopConstraint.constant = -40
  labelUsernameConstraint.constant = -40
  usernamePasswordConstraint.constant = -40
  passwordButtonConstraint.constant = -40
}

override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let duration = 0.5
    let delay = 0.1
    let damping = CGFloat(0.6)
    let springVelocity = CGFloat(0.0)

    labelTopConstraint.constant = 30
    UIView.animate(withDuration: duration,
                   delay: 0.0,
                   usingSpringWithDamping: damping,
                   initialSpringVelocity: springVelocity,
                   options: [],
                   animations: {
                    
                    self.view.layoutIfNeeded()
    }, completion:nil)

    labelUsernameConstraint.constant = 8
    UIView.animate(withDuration: duration,
                   delay: delay,
                   usingSpringWithDamping: damping,
                   initialSpringVelocity: springVelocity,
                   options: [],
                   animations: {
                    
                    self.view.layoutIfNeeded()
    }, completion: nil)

    usernamePasswordConstraint.constant = 8
    UIView.animate(withDuration: duration,
                   delay: delay*2,
                   usingSpringWithDamping: damping,
                   initialSpringVelocity: springVelocity,
                   options: [],
                   animations: {
                    
                    self.view.layoutIfNeeded()
    }, completion: nil)

    passwordButtonConstraint.constant = 8
    UIView.animate(withDuration: duration,
                   delay: delay*3,
                   usingSpringWithDamping: damping,
                   initialSpringVelocity: springVelocity,
                   options: [],
                   animations: {
                    
                    self.view.layoutIfNeeded()
    }, completion: nil)
}
{% endhighlight %}

In `viewWillAppear` we set the constants of the constraints such that all elements are off screen. In `viewDidAppear` we set the constants to the final values and tell the layout engine that we would like to animate the change. The values of the four animations are the same except for the delay. Each of the animations starts a bit later that the previous one.


Now let's add tweaks to fine tune the animation values. To be able to use DDHTweaks, we need to add the framework to the project (for example with Carthage) and import it into the file. Then we just have to replace the assignment of the animation values with this:

{% highlight swift %}
let duration = 0.5.tweak("Animation/Duration", min: 0, max: 5)
let delay = 0.1.tweak("Animation/Delay", min: 0, max: 1)
let damping = CGFloat(0.6.tweak("Animation/Damping", min: 0, max: 1))
let springVelocity = CGFloat(0.0.tweak("Animation/Spring Velocity", min: 0, max: 10))
{% endhighlight %}

We are not done yet. We need a way to show the DDHTweaks-UI. Import the DDHTweaks to AppDelegate.swift and replace the line

{% highlight swift %}
var window: UIWindow?
{% endhighlight %}

with this

{% highlight swift %}
var window: UIWindow? = ShakeableWindow(frame: UIScreen.main.bounds)
{% endhighlight %}

With this change you can bring the DDHTweaks-UI onto screen by shaking the iDevice or choosing `Hardware / Shake Gesture` in the Simulator. In the demo app there are two screens with tweakable values.

![]({{ site.baseurl }}/assets/20161205_2211_tweakable_views.png)

When we select the login screen, we get all the values that can be changed for the animation. After some iterations we finally find out what the best values are:

![]({{ site.baseurl }}/assets/20161205_2215_animation_values.png)

After we found the perfect values for the login animation, we can export them on the main screen of the DDHTweaks-UI by sending a mail.

If you need more information, head over to the [git repository](https://github.com/dasdom/DDHTweaks) and read the Readme or the code. And let me know what you think about it on [twitter](https://twitter.com/swiftpainless).

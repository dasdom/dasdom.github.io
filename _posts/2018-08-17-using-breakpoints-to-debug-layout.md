---
layout: post
title:  "Debugging View Layouts with Breakpoints"
date:   2018-08-17
categories: debugging
---

[I don't like the Interface Builder.]({{ site.baseurl }}/why-i-still-dont-like-the-interface-builder/) When doing the interface in code (and even sometimes when using the Interface Builder) I'd like to see at runtime where exactly the views are positioned. Depending on the contents and the background color of the views this is not always easy.

I the past I usually changed the background color of some views and recompiled the app to see the frames of the views in the simulator. But this approach has several disadvantages.

First I needed to change the code just to be able to visually debug my layout. Second I needed to stop the debugging session and recompile to make the change visible in the simulator.

Then I saw the great WWDC session [Advanced Debugging with Xcode and LLDB](https://developer.apple.com/videos/play/wwdc2018/412/) and thought, LLDB might have some tricks to make this process easier. And indeed it does.

Let's assume we have a login in our app. That might look like this:

{:refdef: style="text-align: center;"}
![Login screen]({{ "/assets/2018-08-17-using-breakpoints-1.png" | absolute_url }})
{: refdef}

In the debug navigator in the lower left corner is a plus button. If you click it, you can add breakpoints. Add a symbolic breakpoint with the trigger `-[UIView didAddSubview:]` and add a the Debugger Command:

{% highlight objc %}
e [(UIView *)$arg3 setBackgroundColor:[UIColor colorWithHue:($arg3 % 100)/100.0 saturation:1.0 brightness:1.0 alpha:0.5]]
{% endhighlight %}

In Xcode 9 the UI looks like this:

{:refdef: style="text-align: center;"}
![Login screen]({{ "/assets/2018-08-17-using-breakpoints-2.png" | absolute_url }})
{: refdef}

If you now navigate to the login screen, you see something like this:

{:refdef: style="text-align: center;"}
![Login screen]({{ "/assets/2018-08-17-using-breakpoints-3.png" | absolute_url }})
{: refdef}

That's ... interesting.

Maybe that is to much and you just want to add a border to each view. Then change the Debugger Command to:

{% highlight objc %}
e [[(UIView *)$arg3 layer] setBorderColor:[[UIColor magentaColor] CGColor]]; [[(UIView *)$arg3 layer] setBorderWidth:1];
{% endhighlight %}

If you navigate to the login screen, you should see something like this:

{:refdef: style="text-align: center;"}
![Login screen]({{ "/assets/2018-08-17-using-breakpoints-4.png" | absolute_url }})
{: refdef}

Nice! So with these breakpoints you can always visually check the frames of you views without recompiling the app. You can even go one essential step further. You make these breakpoints available in all your projects by ctr-clicking on each breakpoint and selecting 'Move Breakpoint To > User'.

If you have so feedback, ping be on [Twitter](https://twitter.com/dasdom).

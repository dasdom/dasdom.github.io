---
layout: post
title: Minimal Distance To Two Views In Auto Layout
date: 2015-12-08 21:58:00.000000000 +01:00
type: post
published: true
status: publish
categories:
- Auto Layout
tags:
- auto layout
- NSLayoutConstraint
- Visual Format Language
---
Let's say you have three subviews in a view. Two subviews at the top and
the third one below. The views at the top can have different heights and
it's not clear which one is taller. Now we want to have the Auto Layout
to manage that the distance of the view at the bottom to the views at
the top is at least 10 points.

How can we do that? The trick ist to implement it using inequalities and
priorities. The relevant constrains look like this:

{% highlight swift %}
leftViewConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:[red(50)]-(>=10)-[green]", options: [], metrics: nil, views: leftViews)
leftViewConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:[blue(100)]-(>=10)-[green]", options: [], metrics: nil, views: leftViews)
leftViewConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:[blue(100)]-(<=10@999)-[green]", options: [], metrics: nil, views: leftViews)
{% endhighlight %}

<!--more-->
Both views at the top have a minimal constraint to the bottom view. In
addition one of the view has a maximal constraint to the bottom view but
with priority of 999.

That's it. In the following screenshot you can see the result. On the
left, the blue view has a height of 100 points and the red view has a
height of 50. On the right it's the opposite:

![]({{ site.baseurl }}/assets/Screen-Shot-2015-12-08-at-21.52.25-300x155.png)

You can find the playground with the complete example
[here](http://swift.eltanin.uberspace.de/wp-content/uploads/2015/12/MinimalDistanceAutoLayoutPlayground.playground.zip).

---
layout: post
date: 2018-09-11
categories: without ib
title: "Fun With iOS III: What is a geofence?"
---

This post is part of a series in which we build a geofence App.

In the app we are going to build, the user will be able to add geofences. To understand what we need to build to make that possible, let's see what a geofence looks like. Geofences are added using the following method of `CLLocationManager`:

{% highlight swift %}
func stopMonitoring(for region: CLRegion)
{% endhighlight %}

`CLLocationManger` is a class in the Core Location framework.

This means, we define a geofence as a `CLRegion`. But [the documentation from Apple states](https://developer.apple.com/documentation/corelocation/clregion) that `CLRegion` is an abstract class:

> In iOS, this class is abstract and you do not create instances of this class directly; instead, you instantiate subclasses that define specific types of regions.

One of the subclasses provided by Apple is `CLCircularRegion` with the initialiser:

{% highlight swift %}
init(center: CLLocationCoordinate2D, 
     radius: CLLocationDistance, 
     identifier: String)
{% endhighlight %}

So here is finally the answer. To setup a geofence we need a coordinate, a radius and an identifier. For the identifier, we will create a unique id. The radius will be a fixed value, let's say 20 meters. Later it would be good to let the user decide how big the radius should be. But for the start it's enough to have a fixed value.

For the coordinate, we need to figure out the location of the device the app is running on. This can be done again using an instance of `CLLocationManager`. If you have used an iOS device before (and as you're reading this, I'm sure you have) you definitely have seen the authorisation request whether the app is allowed to get the location of the device. This is what we have to do in our app.

In the next post in this series we are going to write our first test to guide the development.

You might ask why we write the test before there is anything to test. This is called Test-Driven Development (TDD) and it's a good idea for several reasons. Go, look up the term TDD in the internet.
 
We are using it here because it guides the development and the thought process. By starting with a failing test (it fails because there is nothing that could make the test pass), we make sure that the test does not always pass. It could be that we have a test that passes, because we made a mistake. We could be falsely confident that our app works because all the tests pass.   

Before we continue writing the geofence app we'll need to learn the basics of TDD.

If you have any feedback ping me on [Twitter](https://twitter.com/dasdom).
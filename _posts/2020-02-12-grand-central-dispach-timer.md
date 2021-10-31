---
layout: post
date: 2020-02-12 12:53
title: Grand Central Dispatch Timer
author: Dominik Hauser
description: How to build a timer that works on a background thread.
tags: Xcode, Breakpoints
---

Last week I needed to fire a timer on a background thread.
You can do this with a `Timer` that is added to a run loop on a background thread.

Here is a different approach using Grand Central Dispatch.
This method returns a timer that fires on a background thread.

```swift
func gcdTimer(delay: DispatchWallTime = .now(),
              repeating: DispatchTimeInterval = .never,
              leeway: DispatchTimeInterval = .milliseconds(100),
              action: @escaping ()->Void) -> DispatchSourceTimer {
  
  let queue = DispatchQueue(label: "de.dasdom.my.queue")
  let timer = DispatchSource.makeTimerSource(queue: queue)
  timer.schedule(wallDeadline: delay, repeating: repeating, leeway: leeway)
  timer.setEventHandler(handler: action)
  timer.resume()
  return timer
}
```

First we create a `DispatchQueue`.
With this queue we create a `DispatchSourceTimer`.
In the next line we schedule the timer using a delay, a repeating interval and a leeway.
The leeway gives the system some flexibility in how it manages the system resources.
Next we add the action that should be executed when the timer fires.
Don't forget to call `resume()` on the timer.

To invalidate the timer call `cancel()` on it.

That's it.
This is a timer that fires on a background thread.

I thought about putting that into a Swift Package.
But that felt a lot like [leftpad](https://www.theregister.co.uk/2016/03/23/npm_left_pad_chaos/).
So I wrote a blog post about it to find it again when I need it.

Follow me on [Twitter](https://twitter.com/dasdom).   
Check out my open source code at [Github](https://github.com/dasdom).

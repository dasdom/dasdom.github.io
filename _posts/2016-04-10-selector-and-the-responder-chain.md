---
layout: post
title: '#selector() and the responder chain'
date: 2016-04-10 17:42:27.000000000 +02:00
type: post
published: true
status: publish
categories:
- General
tags:
- Responder Chain
- Selector
- Swift 2.2
- update
---
With the new syntax for selectors in Swift 2.2 the approach I used in
["Utilize the responder chain for target
action"](http://swiftandpainless.com/utilize-the-responder-chain-for-target-action/)
produces a warning. Let's fix that.

Protocols for president
-----------------------

First we add a protocol:

{% highlight swift %}
@objc protocol DetailShowable {
  @objc func showDetail()
}
{% endhighlight %}

Then we can add an extension to `Selector` as
described in [this awesome
post](https://medium.com/swift-programming/swift-selector-syntax-sugar-81c8a8b10df3#.6gteb7p1s)
by [Andyy Hope](https://twitter.com/AndyyHope) that looks like this:

{% highlight swift %}
private extension Selector {
  static let showDetail = #selector(DetailShowable.showDetail)
}
{% endhighlight %}
<!--more-->

Adding the action to the responder chain is then as easy as this:

{% highlight swift %}
button.addTarget(nil,
                 action: .showDetail,
                 forControlEvents: .TouchUpInside)
{% endhighlight %}

Then some responder object in the responder chain needs to conform to
the `DetailShowable` protocol.

You can find the code on
[github](https://github.com/dasdom/SelectorSyntaxSugar).

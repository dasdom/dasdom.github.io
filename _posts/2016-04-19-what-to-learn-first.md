---
layout: post
title: What to learn first
date: 2016-04-19 08:11:18.000000000 +02:00
type: post
published: true
status: publish
categories:
- General
- Swift
- TDD
tags:
- Beginner
- functional
- functional programming
- learning
- TDD
- What
---

Yesterday I got asked, what a Swift beginner should learn first. Here is
the question:

> I did want to ask you something, is it worth a while to learn TDD, or
> spend that time learning Swift, and functional programming?

Of course, my opinion is a bit biased as I wrote a [book about TDD with
Swift](http://swiftandpainless.com/book/). So, keep that in mind when
you read my answer.

**Advice \#1: Read the [Swift
Book](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/)
provided by Apple.**

In my opinion you should first learn Swift. This is the basis of
everything. If you don't understand what functions can do in Swift, you
won't understand the concepts of functional programming in Swift. In
addition, Swift is still mainly used to write apps for iOS and OS X.
This means, most of the time you need to interact with object oriented
APIs (at least at the time of writing ;)). So you also need to
understand object oriented Swift to leverage the potential of Swift when
writing Swift.

And even if you don't believe me, this is what Chris Eidhof, Florian
Kugler, and Wouter Swierstra write in [Functional
Swift](https://www.objc.io/books/functional-swift/):

> „You should be comfortable reading Swift programs and familiar with
> common programming concepts, such as classes, methods, and variables.
> If you’ve only just started to learn to program, this may not be the
> right book for you.“
<!--more-->

**Advice \#2: Read a ton of blog posts. There are so many great Swift
blogs.**

The book by Apple is very good. But if you want to see what all those
creative minds in the community come up with, you need to read many
blogs.

**Advice \#3: Learn writing tests and use the knowledge to write tests
for your code.**

In my opinion testing is essential. Every developer should test their
code. There are so many benefits to a good test harness. [Michael
Feathers](https://twitter.com/mfeathers) writes in [Working Effectively
with Legacy
Code](http://www.goodreads.com/book/show/44919.Working_Effectively_with_Legacy_Code?from_search=true):

> To me, legacy code is simply code without tests.

For me Test-Driven Development is good to start with tests because the
question what to test is secondary. You (kind of) write tests for
(nearly) everything. One of the rules in TDD is that you only write code
if you have a failing test.

**Advice \#4: Learn functional programming.**

Swift also has functional aspects. You don't need to use them, but if
you are (or willing to become) active in den community, you most
probably will encounter functional magic soon. In my opinion, learning
functional programming makes you a better developer. Often functional
code looks like magic at first. It *just* works (which you can prove
because you have tests).

This is my opinion. I am sure that there are many developer with
different opinions. Go on, ask them what they think about it.

And, buy my book. ;)

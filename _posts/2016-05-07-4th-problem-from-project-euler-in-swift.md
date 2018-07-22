---
layout: post
title: 4th Problem from Project Euler in Swift
date: 2016-05-07 16:49:44.000000000 +02:00
type: post
published: true
status: publish
categories:
- General
- Swift
tags:
- Optimization
- Performance
- Project Euler
- String
- Swift
---
Yesterday I read [this post](http://tech.jjude.com/double-loops/) by
[Joseph Jude](https://twitter.com/jjude). He experienced that Swift is
way slower in solving the 4th problem from Project Euler when compared
to Python and Typescript.

The [4th problem in Project Euler](https://projecteuler.net/problem=4)
is this:

> A palindromic number reads the same both ways. The largest palindrome
> made from the product of two 2-digit numbers is 9009 = 91 × 99.
<!--more-->
> Find the largest palindrome made from the product of two 3-digit
> numbers.

The solution of Joseph looked like this:

{% highlight swift %}
var answer = 0
var k = 0
var s = ""
for i in (100...999).reverse() {
  for j in (100...i).reverse() {
    k = i * j
    s = String(k)
    if s == String(s.characters.reverse()) && k > answer {
      answer = k
    }
  }
}

print(answer)
{% endhighlight %}

He states that this code needs 22 seconds to execute. Wow, 22 seconds.
This is a lot. Especially when compared to Python. Joseph writes that
the Python version takes 0.33 seconds to execute.

One reason for Swift being that slow is that the initialization of
strings is quite expensive. Swift strings are very complicated. Another
reason is that Joseph presumably compiled without any optimization. So
let's see what happens when we fix both problems.

First let's get rid of the String creation. This is a solution without
strings:

{% highlight swift %}
let dateBefore = NSDate()
var answer = 0
for i in (100...999).reverse() {
  for j in (100...i).reverse() {
    var value: Int = i * j
    let temp: Int = value
    var array: [Int] = []
    while (value > 0) {
      array.append(value%10)
      value = value/Int(10)
    }
    if temp > answer && array == array.reverse() {
      answer = temp
    }
  }
}

let diff = dateBefore.timeIntervalSinceNow
print("\(diff) \(answer)")
{% endhighlight %}

I have added code to measure the execution time. Without any
optimization I get an execution time of 0.84 seconds on my MacBook Air.
With an optimization of Fast \[-O\] the execution time goes down to 0.42
seconds.

I think there is still room for improvement in the algorithm but 0.42 is
already way better than 22.

---
layout: post
title: Implementing SequenceType
date: 2015-07-31 15:30:10.000000000 +02:00
type: post
published: true
status: publish
categories:
- Swift
tags:
- GeneratorType
- protocol
- SequenceType
- Swift
---
Sometimes you have a struct/class that holds some kind of sequence and
you would like to iterate over it with `for ... in ...`. In
Swift the struct/class has to conform to `SequenceType` to
enable this iteration.

Let's say you have a simple struct to hold domains:

{% highlight swift %}
struct Domains {
  let names: [String]
  let tld: String
}
{% endhighlight %}

To conform to `SequenceType` the
struct needs to implement the method:

{% highlight swift %}
func generate() -> Self.Generator
{% endhighlight %}

and the `Generator` is of type
`GeneratorType`. Ok, let's start with the generator.
<!--more-->

The protocol `GeneratorType` looks
like this:

{% highlight swift %}
protocol GeneratorType {
  /// The type of element generated by `self`.
  typealias Element
  
  /// Advance to the next element and return it, or `nil` if no next
  /// element exists.
  mutating func next() -> Self.Element?
}
{% endhighlight %}

So, the generator need to implement a method `next()` that returns
the next element until no element is left.

A simple generator for the Domains struct could look like this:

{% highlight swift %}
struct DomainsGenerator : GeneratorType {
    
  var domains: Domains
  var index = 0
    
  init(domains: Domains) {
    self.domains = domains
  }
    
  mutating func next() -> String? {
    return index < domains.names.count ? "\(domains.names[index++]).\(domains.tld)" : nil
  }
}
{% endhighlight %}

The method is mutating because it changes the index property.

The Domains struct would then conform to `SequenceType` like
this:

{% highlight swift %}
func generate() -> DomainsGenerator {
  return DomainsGenerator(domains: self)
}
{% endhighlight %}

The complete example looks like this:

{% highlight swift %}
struct Domains {
  let names: [String]
  let tld: String
}

extension Domains : SequenceType {
  func generate() -> DomainsGenerator {
    return DomainsGenerator(domains: self)
  }
  
  struct DomainsGenerator : GeneratorType {
    
    var domains: Domains
    var index = 0
    
    init(domains: Domains) {
      self.domains = domains
    }
    
    mutating func next() -> String? {
      return index < domains.names.count ? "(domains.names[index++]).(domains.tld)" : nil
    }
  }
}

let domains = Domains(names: ["swiftandpainless","duckduckgo","apple","github"], tld: "com")

for domain in domains {
  print(domain)
}
{% endhighlight %}
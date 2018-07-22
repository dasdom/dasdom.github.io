---
layout: post
title: NSCoding And Swift Structs
date: 2015-08-19 16:49:22.000000000 +02:00
type: post
published: true
status: publish
categories:
- Strange Ideas
tags:
- NSCoding
- Struct
- Swift
---
As you all know `NSCoding` doesn't
work with Swift structs. `NSCoding` only works
for classes inheriting from `NSObject`. But the
next (or current) big thing are structs. Value types all the way. So we
need a way to archive and unarchive instances of structs.

[Janie](https://twitter.com/redqueencoder)
[wrote](http://redqueencoder.com/property-lists-and-user-defaults-in-swift/)
about how they solved it at Sonoplot where she works.

**Tl;dr**: They define a protocol that has two methods: one for getting
an `NSDictionary` out of
a struct and one for initializing the struct with an `NSDictionary`. The
`NSDictionary` is then serialized using `NSKeyedArchiver`. The
beauty of this approach is that each struct conforming to that protocol
can be serialized.

I came up with an other approach. It just popped up in my mind. And even
after experimenting with it and implementing a little toy project I'm
still not sure if this is a good idea. It's definitely not as beautiful
as the approach mentioned above. I put it here to let you decide.
<!--more-->

Let's say we have a person struct:

{% highlight swift %}
struct Person {
  let firstName: String
  let lastName: String
}
{% endhighlight %}

So we can't make this conforming to `NSCoding` but we can
add a class **within** the **Person** struct that conforms to `NSCoding`:

{% highlight swift %}
extension Person {
  class HelperClass: NSObject, NSCoding {
    
    var person: Person?
    
    init(person: Person) {
      self.person = person
      super.init()
    }
    
    class func path() -> String {
      let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
      let path = documentsPath?.stringByAppendingString("/Person")
      return path!
    }
    
    required init?(coder aDecoder: NSCoder) {
      guard let firstName = aDecoder.decodeObjectForKey("firstName") as? String else { person = nil; super.init(); return nil }
      guard let laseName = aDecoder.decodeObjectForKey("lastName") as? String else { person = nil; super.init(); return nil }
      
      person = Person(firstName: firstName, lastName: laseName)
      
      super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
      aCoder.encodeObject(person!.firstName, forKey: "firstName")
      aCoder.encodeObject(person!.lastName, forKey: "lastName")
    }
  }
}
{% endhighlight %}

So, what is happening here. We have just added a class within the
**Person** struct that conforms to `NSCoding` which means
it implements the methods `init?(coder aDecoder: NSCoder)` and 
`encodeWithCoder(aCoder: NSCoder)`. The class has a property of type 
`Person` and in `encodeWithCoder(aCoder: NSCoder)` 
it writes the values of the properties of the person
instance to the coder and in `init?(coder aDecoder: NSCoder)` it 
reads those values again from the decoder and creates
a new person instance.

What's left is to add encoding and decoding methods to the **Person**
struct:

{% highlight swift %}
struct Person {
  let firstName: String
  let lastName: String
  
  static func encode(person: Person) {
    let personClassObject = HelperClass(person: person)
    
    NSKeyedArchiver.archiveRootObject(personClassObject, toFile: HelperClass.path())
  }
  
  static func decode() -> Person? {
    let personClassObject = NSKeyedUnarchiver.unarchiveObjectWithFile(HelperClass.path()) as? HelperClass

    return personClassObject?.person
  }
}
{% endhighlight %}

With this code we create a **HelperClass** object to make the archiving
and unarchiving.

The struct is used like this:

{% highlight swift %}
let me = Person(firstName: "Dominik", lastName: "Hauser")
    
Person.encode(me)
    
let myClone = Person.decode()
    
firstNameLabel.text = myClone?.firstName
lastNameLabel.text = myClone?.lastName
{% endhighlight %}

You can find the code for this experiment on
[github](https://github.com/dasdom/EncodeExperiments).

If you enjoyed this post, then make sure you subscribe to my
[feed](http://swiftandpainless.com/feed).

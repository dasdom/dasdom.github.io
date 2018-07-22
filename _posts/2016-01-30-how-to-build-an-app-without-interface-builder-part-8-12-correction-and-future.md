---
layout: post
title: 'How To Build An App Without Interface Builder – Part 8 1/2: Correction and
  Future'
date: 2016-01-30 22:07:21.000000000 +01:00
type: post
published: true
status: publish
categories:
- General
- TDD
tags:
- Book
- Correction
- Github
- pull-requests
- Series
- TDD
---
Again I haven't written a post in a long time in this series. And even
this post isn't a real post. It's just a correction and and I'll tell
you the reason why I was so busy during the last months. There will be a
real post soon. Stay tuned. :)
<!--more-->

But first let's correct two bugs from the last post. [Stefan
Jager](https://github.com/StefanJager) figured out that the comparison
of the today date and the date of the birthday of the person didn't work
as expected. He was so kind to create a pull-request and I merged it.
You can find the pull-request
[here](https://github.com/dasdom/Birthdays/pull/1/files). Thanks Stefan!

In the same function [Stefan Scheidt](https://github.com/stefanscheidt)
found another problem and improved the code. Please find the
pull-request [here](https://github.com/dasdom/Birthdays/pull/3/files).
Thanks Stefan!

I combined the fixes from both pull-requests. The final version of the
`progressUntilBirthday(_:)`
method looks like this:

{% highlight swift %}
func progressUntilBirthday(birthday: Birthday) -> Float? {
  
  let calculationComponents = birthday.birthday.copy() as! NSDateComponents
  if let todayComponents = todayComponents {
    calculationComponents.year = todayComponents.year
    
    if calculationComponents.month < todayComponents.month ||
      (calculationComponents.month == todayComponents.month &&
        calculationComponents.day < todayComponents.day) {
      
      calculationComponents.year += 1 // Swift 3 compliant ...
    }
    
    let components = gregorian?.components([.Day],
                                           fromDateComponents: todayComponents,
                                           toDateComponents: calculationComponents,
                                           options: [])
    
    return 1.0-Float(components!.day)/Float(365)
  } else {
    return nil
  }
}
{% endhighlight %}

You can find the final version on
[github](https://github.com/dasdom/Birthdays/tree/8.5).

Now to something completely different
-------------------------------------

When I started this series, I planed to publish a post every week. This
didn't work the last months. And here is why.

I wrote (and kind of am still writing) [a book about Test-Driven
Development](https://www.packtpub.com/application-development/test-driven-development-swift).
You may have heard that writing a book is a lot of work. That is true.
In addition I had a four day work week and my lovely small family.

Now that the books is nearly finished I'm quite confident that I can
continue this series.

Thank you for your patience!

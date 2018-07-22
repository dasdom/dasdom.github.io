---
layout: post
title: Using a Playground instead of Keynote
date: 2016-04-22 13:20:15.000000000 +02:00
type: post
published: true
status: publish
categories:
- General
- Swift
tags:
- playground
- Presentation
- Swift
- Takeaways
meta:
  _wpcom_is_markdown: '1'
  _edit_last: '1'
  apss_content_flag: '0'
  _flattr_post_hidden: '0'
  _flattr_post_customurl: ''
  twitterCardType: summary
  robotsmeta: index,follow
  title: Using a Playground instead of Keynote
  description: Yesterday I gave a talk at the Cologne Swift meetup and I tried something
    new. I used a Swift Playground for the "Slides".
  keywords: Swift, Playground, Presentation, Takeaways
  cardImage: http://swift.eltanin.uberspace.de/wp-content/uploads/2016/04/Functions-Basics-I.xcplaygroundpage-2016-04-22-09-22-36.png
---

Yesterday I gave a talk at the Cologne Swift meetup and I tried
something new. I used a Swift Playground for the "Slides".

![Functions - Basics I.xcplaygroundpage 2016-04-22
09-22-36]({{ site.baseurl }}/assets/Functions-Basics-I.xcplaygroundpage-2016-04-22-09-22-36.png)
<!--more-->
These are my takeaways:

Presentation mode
-----------------

Xcode has a presentation mode. But as the resolution of the beamer may
be different to the resolution of your Mac, you might have to change the
font size to make all the text fit on the screen for each slide and
still be readable.

**Takeaway \#1: Anticipate that the "slides" look a bit different on the
beamer.**

Too many pages
--------------

At the end the Playground had 49 pages. This seems to me a bit too much
for Xcode 7.3. During preparation Xcode crashed several times and the
day before the presentation my Mac froze completely and had to me forced
rebooted.

**Takeaway \#2: Next time I will split the Playground into several
smaller ones.**

Answering questions
-------------------

Even though I was a bit worried that the Xcode could crash, it was nice
to be able to answer small questions right away in the live Playground.
I could change something in the code to answer the question or to figure
out what the question actually is about. This was really nice.

**Takeaway \#3: Answering questions is a lot easier when you can show
the working (or crashing) code live in the Playground.**

Navigation
----------

You might have noticed in the screenshot that I have added "buttons" to
navigate to the previous and next slide. This is done using emoji and
the `@previous` and `@next` keywords. Unfortunately you cannot map the
actions to the arrow keys. So you have to click on the "buttons" with
the cursor.

**Takeaway \#4: Cannot be controlled with keys or a clicker (yet).**

Conclusion
----------

I really enjoyed to present an introduction to Swift in a Playground and
will use it again, when the topic is appropriate.

The Playground I used is on
[github](https://github.com/dasdom/Swiftandpainless). You can use it for
you own talk. I would appreciate if you have a link to the original
Playground somewhere in it (don't need to be shown during the talk).

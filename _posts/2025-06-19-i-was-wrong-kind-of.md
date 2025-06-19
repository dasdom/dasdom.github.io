---
layout: post
date: 2025-06-19 06:00
title: I was wrong
description: Kind of
tags: Xcode, SwiftUI, UX, UI
---

In a recent [post on Mastodon](https://chaos.social/@dasdom/114683426476942144) I expressed my
frustration that user interfaces Apple engineers build with SwiftUI tend to be so bad, they could be
from a very old Windows version.

<img src="../../../assets/2025-06-19/initial_post_on_mastodon.png" height="300"/>

This new user interface is garbage.
It gets worse when you realize that this had to be implemented by a person working on Xcode.
This poor person had to build a user interface that is clearly designed for a bad toy software into a
software they have to use every day.

So [I assumed](https://chaos.social/@dasdom/114702314515072133) the reason has to be that it's easier to build bad user interfaces in SwiftUI on the Mac.
To proof me wrong I build the Behavior settings user interface from Xcode 16 myself using SwiftUI.

It turned out, **I indeed was wrong.**   
Kind of.

It is very easy to build the user interface from Xcode 16 using SwiftUI.
Even a person like me, who hates and avoids SwiftUI with a passion can build a usable user interface
with it.

(I ignored data handling and there is a bug that the selection of the table on the left side isn't
shown, but apart from that, this seems to work.)

<figure>
    <img src="../../../assets/2025-06-19/xcode_16_demo_swiftui.png" height="400"/>
    <figcaption>My experiment for a usable Behaviors setting build with SwiftUI.</figcaption>
</figure>

So the question is, why did Apple choose to build such a horrible user interface?

<figure>
    <img src="../../../assets/2025-06-19/behaviors_settings_xcode26.png" height="400"/>
    <figcaption>The Behavior setting in Xcode 26..</figcaption>
</figure>

What do you think?

Let me know on [Mastodon](https://chaos.social/@dasdom).

(No AI was used to write this post.)

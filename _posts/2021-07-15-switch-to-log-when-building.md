---
layout: post
date: 2021-07-15 12:00
title: Automatically Switch to Build Log
description: Xcode can switch to the build log automatically when building starts. Here is how.
tags: Xcode, Behaviors, Tips, Tricks
---

One often overlooked feature of Xcode are Behaviors.
I will go into more detail about Behaviors and how I used them in a future post.

In this post I show you, how to setup a Behavior that switches to a new tab when building starts and shows the build log in that tab.

First open the Behaviours settings in Xcode at *‘Xcode / Behaviors / Edit Behaviors…’*.
Select *‘Build / Starts’* and check the check box at *‘Show window tab’* and put in the name 🪵.
Then check the box at *‘Navigate to current log’*.

<img src="../../../assets/2021-07-15/swith_to_build_log.png" width="500"/>

With this Behavior, Xcode switches to the 🪵 tab when building starts and shows the build log in that log.

<img src="../../../assets/2021-07-15/xcode_showing_build_log.png" width="500"/>

You should add a Behavior that switches back to the normal development tab, when building finishes.
My development tab is named 🤓 so the Behavior looks like this:

<img src="../../../assets/2021-07-15/switch_back_to_dev.png" width="500"/>

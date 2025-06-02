---
layout: post
date: 2025-06-02 06:00
title: Frames in the iOS simulator in landscape
description: They are wrong
tags: iOS, iOS-simulator, dev-tool, AppKit, Objective-C
---

[I might be building a developer tool for iOS developers.](https://dasdom.dev/building-a-dev-tool/)
Recently I encountered yet another problem.
In landscape the frames of the user interface elements are all wrong.
It looks like they are the frames of the elements in portrait.

<img src="../../../assets/2025-06-02/wrong_frames_in_landscape.png" height="400"/>

To me it looks like landscape on iOS simulator (or maybe even on the real device) is some kind of hack.
First I tried to rotate and shift the frames but this didn't work.
It turned out that the elements would have to be shifted by different amounts.

Next I tried to check how Apple solved this in their demo project.
They didn't.
The demo project had the same problem.

OK, next idea: Accessibility Inspector.
Turns out, if the source is set to the host Mac, I see the same problem.

<img src="../../../assets/2025-06-02/wrong_frame_in_accessibility_inspector.png" height="400"/>

But if I change the source to the iOS simulator, the frames are correct.

<img src="../../../assets/2025-06-02/correct_frame_in_accessibility_inspector.png" height="400"/>

OK...

At the moment I have no idea how I could change the host in my tool to get the same behavior.
I might still release the app with this little flaw.

If you know how to fix this, hints would be highly appreciated!

Until next time, have a nice day, week and month.

(No AI was used to write this post.)

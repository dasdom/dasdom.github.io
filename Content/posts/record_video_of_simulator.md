---
date: 2021-07-30 12:00
description: You could record a video of the simulator screen using the command line for quite some time. Now you can even do that right in the simulator app.
tags: Xcode, Tips, Trick, Simulator, Video
---

# Record A Video Of Your App In The Simulator

A video of your app running on a device or in the simulator shows the potential users not only the user interface but also how the apps feels like.
It shows if the animations are to long and how the parts of the app are connected to each other.
You can use such a video to show off your app on social media.
Or you can add the video to your app page in the App Store.

## The Old Way

For quite some time you could record a video of the simulator screen with the following `simctl` command:

```bash
xcrun simctl io booted recordVideo --codec="h264" "foobar.mov"
```

## The New Way

Since Xcode 12 you can record such a video directly in the Simulator app.
Open you app in the simulator and select the menu item 'File / Record Screen'.

<img src="../../assets/2021-07-30/record_screen_menu_item.png" width="400"/>

But you don't have to use the menu item.
There is even a button in the simulator itself.
When you press the Option key (⌥) the screenshot button becomes a record button.

<img src="../../assets/2021-07-30/record_button_in_simulator.png" width="500"/>

## The Result

After you have stopped the recording, a small window appears next to the simulator showing the result.

<img src="../../assets/2021-07-30/result_in_mini_window.png" width="400"/>

The result window disappears after a few seconds and the recording is stored on the Desktop.
But you can also ⌃click it to show an options menu.

<img src="../../assets/2021-07-30/options_menu.png" width="400"/>

For example the animated GIF of the recording of one of my apps looks like this:

<img src="../../assets/2021-07-30/result.gif" width="300"/>

## Your Turn

After you have now learned how to record a video of the app you are working on, I'd love to see it.
Record a video of your app, post it on Twitter and mention me ([@dasdom](https://twitter.com/dasdom)) that I get notified.

---
layout: post
date: 2021-07-10 12:00
title: Make Debugger Console Output Stand Out
description: Sometimes debugger output is hard to find in the debug console because of all the noise. Changing the text color can help.
tags: Xcode, Debugger, Console, Debugging
---

Breakpoints are very powerful.
One feature of breakpoints I use the most is to print the value of a variable.
This can be done by adding the Debugger Command `po myVariable` to a breakpoint like this:

<img src="../../../assets/2021-07-10/breakpoint_with_output.png" width="500"/>

## Debugger Console Output Color

To make this output easier to find in the debug output, we can change its color.
Open Preferences of Xcode and navigate to ‘Themes / Console’.
Then change the color of ‘Debugger Console Output’ to the color you like:

<img src="../../../assets/2021-07-10/change_color_debug_ouput.png" width="500"/>

After you have done that, the `po` output from breakpoints can easily be differentiated from the noise:

<img src="../../../assets/2021-07-10/debug_output_with_color.png" width="500"/>

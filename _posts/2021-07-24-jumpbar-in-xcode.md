---
layout: post
date: 2021-07-24 12:00
title: The Jump Bar In Xcode
description: The jump bar allows fast mouse less navigation in the project.
tags: Xcode, Tips, Tricks, Jump Bar
---

You are using the jump bar all the time when working with Xcode.
In case you wonder what I mean with jump bar, it’s this:

<img src="../../../assets/2021-07-24/jumpbar.png" width="500"/>

The jump bar hosts many useful features.
Let’s work through the most important features from left to right.

## Related Items (Shortcut: ⌃1)

On the left is a button with four adjacent squares.
This button shows the related items for the current context.
The first two items are more general: Recent Files and Locally Modified Files.

<img src="../../../assets/2021-07-24/recent_items.png" width="500"/>

The rest of the items in the list are in the context of the file, type or method the cursor is located in.
For example, I use ‘Callers’ on a daily bases to find call sites of a method I’m working on.

## Editing History (Shortcut: ⌃2)

You probably already know that you can can move back and forward in the files history (the files last open in the code editor) with the shortcut ⌃⌘← and ⌃⌘→ or by clicking the arrows on the left side of the jump bar.
But there is more.
With the shortcut ⌃2 or by long-clicking the left arrow you can access the history of the files you have edited.

<img src="../../../assets/2021-07-24/history.png" width="500"/>

This makes navigating between files you edit regularly in an editing session quite easy.

## Group Items (Shortcut: ⌃5)

In some (most?) projects the files are more or less meaningful grouped in the project navigator.
With the shortcut ⌃5 Xcode shows a menu of the current group.

<img src="../../../assets/2021-07-24/group_items.png" width="500"/>

When you start typing while this menu is open, Xcode filters the items using fuzzy search.
This means when you type ‘ford’ the menu shows the elements ‘FormulasCoordinatorTests.swift’ and ‘FormulaDetail’.

<img src="../../../assets/2021-07-24/filter_results.png" width="500"/>

## File Items (Shortcut: ⌃6)

The shortcut ⌃6 shows all items (types, properties, methods, protocols) in the current file.

<img src="../../../assets/2021-07-24/file_items.png" width="600"/>

Again you can filter the shown items using fuzzy search by starting to typ what you are looking for.
And you can use the arrow keys and return to jump to that item.

## Conclusion

Mastering the jump bar (especially using the shortcuts) lets you navigate quickly to the relevant parts of the current editing session.
Try it.

Follow me on [Twitter](https://twitter.com/dasdom) for more content about iOS development.

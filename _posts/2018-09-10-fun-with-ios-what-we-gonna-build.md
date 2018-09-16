---
layout: post
title: "Fun with iOS (1): What we're going to build"
date: 2018-09-10
categories: without ib
---

You learn best, when you have fun. So let's build a fun app and learn something on the way.

I prefer doing the user interface of iOS apps in code. From all the tutorials and blog posts I have seen, this is rather uncommon. Most developers seem to like Interface Builder. This post series is not about the pros and cons. I've discussed my reasons to do the user interface in code in [a blog posts a few years ago]({{ site.baseurl }}/why-i-still-dont-like-the-interface-builder/).

This blog post series is about *how* to build apps without using Interface Builder. In my opinion every iOS developer should be able to do the user interface in code **and** with Interface Builder.

So, in this series we will build an app as I think it should be build. This means, there will be tests. There will be no Interface Builder. And we will be allowed to make errors on the way. We even might build helper tools to speed up the development or debugging. We will see.

## What we are going to build

In iOS there is the concept of geofences. A geofence is a virtual fence set up on your device and whenever you cross it with you iPhone, the app that added the geofence will be notified. You can build many different interesting features using this technology. I'm sure you already have an idea for a fun little app using geofences.

As an example we will build an app where the user can add geofences for locations and the app will register when the user enters or exits a region. Let's say you set a geofence around your office. The app will register when you entered the office and you will be able to check how long you've been working or how long your commute takes from the office to your home.

We will keep it rather simple. The plan it to have an app that could (and might) be put into the App Store. But we'll try to build it in a way that it can be easily improved.

The code for each blog posts will be available on GitHub.

If you have any feedback please ping be on [Twitter](https://twitter.com/dasdom).

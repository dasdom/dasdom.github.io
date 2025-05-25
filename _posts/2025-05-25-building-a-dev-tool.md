---
layout: post
date: 2025-05-25 06:00
title: Building A Dev Tool
description: Controlling the iOS simulator with the keyboard.
tags: iOS, iOS-simulator, dev-tool, AppKit, Objective-C
---

From time to time I switch off my external trackpad to force myself to use keyboard shortcuts in Xcode.
In principle I know [many useful shortcuts](https://xcode.tips) but I often forget to use them
because I need to think to much about them.
The easiest way to make using them more natural is to use them more.

But when the external trackpad is switched off, I need to use the trackpad of my MacBook to
control the iOS simulator.
I tried apps like [Homerow](https://www.homerow.app) or [Shortcat](https://shortcat.app) but
these do not find all elements in the iOS simulator.
In addition, as they need accessibility access to my Mac I might not be able to use them on my
work Mac (because they can work like keyloggers).

I'm a developer.
So the natural conclusion could be that I have to build such a tool myself.
And this is what I tried.
I'm not done yet and it's still not clear if I will succeed.
Especially as I face some strange problems right now.
But these will be discussed in a later post.
This post is about how I build the tool and what it can do at the moment.

## Demo

<img src="../../../assets/2025-05-25/simclicker_demo.gif" height="400"/>

## SwiftUI or AppKit?

> SwiftUI is a scam.   
-- Dominik Hauser

I don't like SwiftUI.
So I use AppKit.
This comes with another advantage.
I can write the code in Objective-C.
This is a good thing because I like and miss Objective-C a lot.

In addition the Accessibility API is C-based.
Such APIs are easier to use in Objective-C than in Swift.

## How this works

Most Mac apps have some kind of accessibility support.
For example native controls like buttons or text fields expose themselves to the accessibility
system.
Screenreaders or other accessibility tools can find those user interface elements.
Apps can hook into this system.

In the accessibility API the user interface elements have different roles.
For example an `NSButton` has the role `AXButton`.
Elements can be grouped into `AXGroup`s.
A tool can ask the accessibility system for the `AXChildren` of a accessibility element.
And this is what I tried first.

Here is the process.
First the app searches for running iOS simulators and takes the first it finds.
(I might improve that in the future and let the user select from a list of simulators.)

```Objective-C
- (void)findSimulators {
    NSArray<NSRunningApplication *> *applications = [[NSWorkspace sharedWorkspace] runningApplications];
    NSMutableArray<NSString *> *names = [[NSMutableArray alloc] init];
    NSMutableArray<NSRunningApplication *> *simulators = [[NSMutableArray alloc] init];
    for (NSRunningApplication *application in applications) {
        if ([application.bundleIdentifier isEqualToString:@"com.apple.iphonesimulator"]) {
            NSLog(@"simulator: %@", application);

            [simulators addObject:application];

            [names addObject:application.localizedName];
        }
    }

    NSRunningApplication *simulator = simulators.firstObject;
    self.simulatorRef = AXUIElementCreateApplication(simulator.processIdentifier);
    self.simulator = simulator;
    NSLog(@"applicationRef: %@", self.simulatorRef);

    [simulator addObserver:self forKeyPath:@"ownsMenuBar" options:NSKeyValueObservingOptionNew context:nil];
}
```

Then the app searches for the `NSWindow` (role `AXWindow`) and asks it for it's children.
To find the children of an `AXElement` (in this case an `AXWindow`) I use methods from a demo 
project provided by Apple.

```Objective-C
+ (NSArray<NSValue *> *)childrenOfUIElement:(AXUIElementRef)element {
    CFArrayRef children = nil;

    children = (__bridge CFArrayRef)([UIElementUtilities valueOfAttribute:NSAccessibilityChildrenAttribute ofUIElement:element]);

    return (__bridge NSArray<NSValue *> *)(children);
}

+ (id)valueOfAttribute:(NSString *)attribute ofUIElement:(AXUIElementRef)element {
    CFTypeRef result = nil;
    NSArray *attributeNames = [UIElementUtilities attributeNamesOfUIElement:element];

    if (attributeNames) {
        if ( [attributeNames indexOfObject:(NSString *)attribute] != NSNotFound
                &&
        	AXUIElementCopyAttributeValue(element, (CFStringRef)attribute, &result) == kAXErrorSuccess
        ) {
        }
    }
    return (__bridge id)(result);
}
```

Unfortunately there is a bug in the Accessibility API.
If the app recursively asks the `AXElement`s for their children it does not find all elements.
For example in the following screenshot the navigation bar items (back button and the button
on the right) are missing.

<img src="../../../assets/2025-05-25/missing_elements.png" width="400"/>

After some digging and debugging I found out that the navigation bar is exposed as an `AXGroup` but
with no children.
To make sure it's not a bug in my code I used Shortcat with the same result.

<img src="../../../assets/2025-05-25/missing_elements_shortcat.png" width="400"/>

## A different approach

The I tried to define a grid and ask accessibility to find all the elements on the grid cross
sections.
This worked but took significantly longer.
First I was willing to accept the worse performance but then I had an idea.
What if I use the quick method first and for all the `AXGroup` with zero children I then use
the grid method.
This worked.
The tool now quickly finds all user interface elements.
Hooray!

## More problems

The tools works well unless the simulator is in landscape.
For some strange reason the frames of the elements are all wrong in this case.
I'll discuss that in a future post.

Until then, have a nice day, week and month.

(No AI was used to write this post.)

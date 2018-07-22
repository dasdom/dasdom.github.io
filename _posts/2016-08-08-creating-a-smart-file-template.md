---
layout: post
title: Creating a "smart" Xcode file template
type: post
categories:
- Xcode
- Swift
tags:
- File Template
- Code generation
---
Did you know that you can create your own file templates for Xcode? Sure you did. But did you also know that you can create a template that takes a string and puts it into a field you define?

Let's build a file template for a Swift protocol and a protocol extension.

## Create a file template

First things first.

Xcode looks for your custom templates at the location `~/Library/Developer/Xcode/Templates/`. We will start by copying a template that comes with Xcode to that location.
<!--more-->
Open Terminal.app and create a directory for your custom templates like this:

{% highlight bash %}
mkdir -p ~/Library/Developer/Xcode/Templates/File\ Templates/Mine
{% endhighlight %}

Next copy the template for Swift file to the new folder:

{% highlight bash %}
cp -R /Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates/File\ Templates/Source/Swift\ File.xctemplate/ ~/Library/Developer/Xcode/Templates/File\ Templates/Mine/Protocol\ with\ Extension.xctemplate
{% endhighlight %}

When you now create a new file in Xcode, you find the new template in its own section:

![]({{ site.baseurl }}/assets/new_template_in_xcode.png)

But this is only the normal Swift file template. We want something better. Open `___FILEBASENAME___.swift` in Xcode by putting the following into Terminal.app:

{% highlight bash %}
open ~/Library/Developer/Xcode/Templates/File\ Templates/Mine/Protocol\ with\ Extension.xctemplate/___FILEBASENAME___.swift
{% endhighlight %}

Replace its contents with this:

{% highlight swift %}
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___

import Foundation

protocol ___FILEBASENAMEASIDENTIFIER___ {

}

extension ___FILEBASENAMEASIDENTIFIER___ {

}
{% endhighlight %}

Now, open an Xcode project and create a file using your new template. Call it **Foo.swift** and click **Create**.

Xcode creates the following file:

{% highlight swift %}
//  Created by dasdom on 08/08/16.
//  Copyright © 2016 dasdom. All rights reserved.

import Foundation

protocol Foo {
  
}

extension Foo {
  
}
{% endhighlight %}

Nice! But we can do more. Let's say we want to have a template that creates a protocol and an extension with one method. To be able to do that, we need options.

## Options

Open **TemplateInfo.plist** and add an **Options** array. Fill in the values that the plist looks like this:

![]({{ site.baseurl }}/assets/template_info_plist.png)

If you prefere your plists in source code form the complete plist looks like this:

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Kind</key>
        <string>Xcode.IDEFoundation.TextSubstitutionFileTemplateKind</string>
        <key>Description</key>
        <string>An empty Swift file.</string>
        <key>Summary</key>
        <string>An empty Swift file</string>
        <key>SortOrder</key>
        <string>5</string>
        <key>AllowedTypes</key>
        <array>
                <string>public.swift-source</string>
        </array>
        <key>DefaultCompletionName</key>
        <string>File</string>
        <key>MainTemplateFile</key>
        <string>___FILEBASENAME___.swift</string>
        <key>Options</key>
        <array>
                <dict>
                        <key>Identifier</key>
                        <string>productName</string>
                        <key>Required</key>
                        <true/>
                        <key>Name</key>
                        <string>Protocol:</string>
                        <key>Description</key>
                        <string>The name of the protocol to create</string>
                        <key>Type</key>
                        <string>text</string>
                        <key>NotPersisted</key>
                        <true/>
                </dict>
                <dict>
                        <key>Description</key>
                        <string>Method</string>
                        <key>Identifier</key>
                        <string>Method</string>
                        <key>Name</key>
                        <string>Method:</string>
                        <key>Required</key>
                        <string>YES</string>
                        <key>Type</key>
                        <string>text</string>
                        <key>NotPersisted</key>
                        <true/>
                </dict>
        </array>
</dict>
</plist>
{% endhighlight %}

With this you have added two text fields to the file creation process. The first is for the name of the file/protocol. The second will be used to generate a method in the protocol and the extension. Don't forget to save the plist file.

When Xcode creates the file, it uses the values in the text fields and puts them into placeholders in the file template. To see how this works, open `___FILEBASENAME___.swift` again and replace its content with this:

{% highlight swift %}
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___

import Foundation

protocol ___FILEBASENAMEASIDENTIFIER___ {
  func ___VARIABLE_Method___()
}

extension ___FILEBASENAMEASIDENTIFIER___ {
  func ___VARIABLE_Method___() {
    
  }
}
{% endhighlight %}

Don't forget to save the file.

Now, open again an Xcode project, add a new file and select your template. An options window opens:

![]({{ site.baseurl }}/assets/xcode_options_window.png)

Put in **Foo** for the protocol name and **bar** for the method and create the file. The generated code looks like this:

{% highlight swift %}
//  Created by dasdom on 08/08/16.
//  Copyright © 2016 dasdom. All rights reserved.

import Foundation

protocol Foo {
  func bar()
}

extension Foo {
  func bar() {
    
  }
}
{% endhighlight %}

Nice! You have just created a template that can create a protocol with an extension and a method. I'm sure, you will find lot's of other useful templates to create. Also have a look at the templates provided by Apple to find out what's possible.

I'd love to read your feedback about this. You can find me on [Twitter](https://twitter.com/dasdom).

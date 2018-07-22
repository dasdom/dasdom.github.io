---
layout: post
title: Utilize The Responder Chain For Target-Action
date: 2016-01-01 11:27:07.000000000 +01:00
type: post
published: true
status: publish
categories:
- Tips
tags:
- button
- Responder Chain
- Swift
- Target-Action
- UIView
- UIViewController
---
I don't know about you, but I tend to forget that there is a responder
chain in iOS. This post is to remind myself (and you) that the responder
chain exists and that we can use it to react to button events.

The Responder Chain
-------------------

In iOS, events (for example touch events) are delivered using the
responder chain. The responder chain consists of responder objects
([Apples words, not
mine](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/event_delivery_responder_chain/event_delivery_responder_chain.html#//apple_ref/doc/uid/TP40009541-CH4-SW1)).
If you have a look at the documentation, you may have noticed that `UIView` and 
`UIViewController` are
responder objects. This means they inherit from `UIResponder`:

![]({{ site.baseurl }}/assets/UIViewDocumentation.png)

When the user taps a view in the view hierarchy, iOS uses hit testing to
figure out which responder object should get the touch event first. The
process starts at the lowest level, the window. Then is propagates up
the view hierarchy and checks for each view if the touch happened within
its bounds. The last view in that process that got hit, receives the
touch event first. If that view does not respond to the touch event, the
event is passed to the next responder in the responder chain. Apple has
a nice example how this works
[here](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/event_delivery_responder_chain/event_delivery_responder_chain.html#//apple_ref/doc/uid/TP40009541-CH4-SW4).
When a view tells iOS that it did not get hit, the subviews of that view
aren't checked.

This has an interesting consequence. When a button is outside of the
bounds of its superview but visible because `clipsToBounds` of the
superview is set to `false`, it does not
receive any touch events. So, when ever a button doesn't work, remember
to check if it is in the bound of its superview.
<!--more-->

Target-Action
-------------

The target-action mechanism can be set up that is also uses the
responder chain by setting the target to `nil`. Then iOS asks
the first responder if it handles the action. If not the first responder
passes the action to the
[nextResponder](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIResponder_Class/index.html#//apple_ref/occ/instm/UIResponder/nextResponder).

### An Example

Here is an example. Let's say that we have a view with a button and a
label as a subview of a view controllers view. We could set up the view
controller as the target for the button in `viewDidLoad` like this 
`subview.button.addTarget(self, action: "onButtonTap:", forControlEvents: .TouchUpInside)`. 
But we can also set the target to `nil` and use the
responder chain. Here is the subview with the button and the label:

{% highlight swift %}
class ViewWithButtonAndLabel: UIView {
    
    let button: UIButton
    let label: UILabel
    
    override init(frame: CGRect) {
        label = UILabel()
        label.textAlignment = .Center
        label.text = "Touch the button"

        button = UIButton(type: .System)
        button.setTitle("The Button", forState: .Normal)
        button.addTarget(nil, action: "onButtonTap:", forControlEvents: .TouchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .Vertical
        
        super.init(frame: frame)
        
        backgroundColor = .yellowColor()
        
        addSubview(stackView)
        
        stackView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        stackView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
{% endhighlight %}

The important line is highlighted. The target for action of the button
is set to `nil`.
As described above, this means that the action propagates through the
responder chain util a responder object implements the action.

Here is how the view controller looks like:

{% highlight swift %}
class ViewController: UIViewController {
    
    let viewWithButtonAndLabel = ViewWithButtonAndLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        
        view.addSubview(viewWithButtonAndLabel)

        viewWithButtonAndLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["subView": viewWithButtonAndLabel]
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("|-20-[subView]-20-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[subView]-20-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(layoutConstraints)
        
    }

    func onButtonTap(sender: UIButton) {
        viewWithButtonAndLabel.label.text = viewWithButtonAndLabel.label.text == "Yeah!" ? "Touch the button" : "Yeah!"
    }
}
{% endhighlight %}

Even though, we do not set the target explicitly, the `onButtonTap(_:)`
method of the view controller gets called when the button is tapped
because it is the first responder object implementing a method with that
signature.

You can find the example code on
[github](https://github.com/dasdom/ResponderChainDemo).

Conclusion
----------

The responder chain is your friend. Try to understand it. Read the
documentation. Use it to make your code more powerful.

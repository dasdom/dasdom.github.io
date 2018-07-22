---
layout: post
title: 'How To Build An App Without Interface Builder – Part 9: Improvements'
date: 2016-01-31 22:07:33.000000000 +01:00
type: post
published: true
status: publish
categories:
- HowTo
- Interface Builder
- Swift
tags:
- guard
- Improvements
- UITableView
- UITableViewCell
- UITableViewController
---
Since I wrote the table view data source code in Part 8, I have
experimented with table views and table view cells a lot. And I found a
way of setting the data in the cell that I like more now. Most probably
that will change in the future. That is the point of being a developer.
Code I write today will probably scare me in half a year. I fear the day
when this stops. Change of preferences is a good thing. Without it I'd
have stopped improving.
<!--more-->

Before we improve the setting of the cell data, let's first improve the
code of `progressUntilBirthday(_:)`.
The method has a few problems. First, the return type is optional. What
does a nil progress mean? It would be nil, if `todayComponents`
would be nil. That should not happen. We set `todayComponents` in
`didSet` of the `today`
property. And that is set in `viewWillAppear` of
`BirthdaysListViewController`.

A better version would look like this:

{% highlight swift %}
func progressUntilBirthday(birthday: Birthday) -> Float {
  
  guard let todayComponents = todayComponents else { return 0.0 }

  let calculationComponents = birthday.birthday.copy() as! NSDateComponents
  calculationComponents.year = todayComponents.year
  
  if calculationComponents.month < todayComponents.month ||
    (calculationComponents.month == todayComponents.month &&
      calculationComponents.day < todayComponents.day) {
    
    calculationComponents.year += 1 // Swift 3 compliant ...
  }
  
  let components = gregorian?.components([.Day],
                                         fromDateComponents: todayComponents,
                                         toDateComponents: calculationComponents,
                                         options: [])
  
  return 1.0-Float(components!.day)/Float(365)
}
{% endhighlight %}

Much better. Here we use guard to unwrap the `todayComponents` and
if this unexpectedly fails, we return a progress on `0.0`. In this case,
the user would just see the info in the cell without the progress. That
would result in the same behavior as the version before.

Now let us improve the setting of the data to be shown in the cell.
Replace `tableView(_:cellForRowAtIndexPath)`
with this:

{% highlight swift %}
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer, forIndexPath: indexPath) as! BirthdayCell
  
  let birthday = birthdays[indexPath.row]
  cell.updateWithItem(birthday, progress: progressUntilBirthday(birthday))
  
  return cell
}
{% endhighlight %}

The compiler complains the `BirthdayCell` doesn't
have a method `updateWithItem(_:progress:)`.
Let's change that. Add the following code to BirthdayCell:

{% highlight swift %}
func updateWithItem<T>(item: T, progress: Float) {
  if item is Birthday {
    let birthday = item as! Birthday
    nameLabel.text = birthday.firstName
    patternNameLabel.text = birthday.firstName
    birthdayLabel.text = "\(birthday.birthday.day) \(birthday.birthday.month)"

    patternWidthConstraint?.constant = CGFloat(progress)*frame.size.width
  }
}
{% endhighlight %}

This makes the cell responsible to update its UI. I find this pattern
much better than letting the controller or the data provider update the
label and the progress. But keep in mind that with this change, the view
and the model are more coupled than they have been before. The cell now
knows that there is something like a birthday. But it already knew that
in some way. The UI was designed to show the information of a birthday
instance.

If you have difficulties to accept that design, you can add a protocol
(like `BirthdayCellPresentable`)
and let `Birthday` conform to
that protocol.

Another thing to note is, we have implemented `updateWithItem(_:progress:)`
as a generic method. But in this case this doesn't help much. We could
have used the type `Any` instead.

Sure there is still code that could be improved. But that has to wait
for some of the next posts in this series. Stay tuned.

As always, find the code at
[github](https://github.com/dasdom/Birthdays/tree/9).

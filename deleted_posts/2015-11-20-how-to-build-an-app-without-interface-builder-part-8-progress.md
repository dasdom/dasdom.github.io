---
layout: post
title: 'How To Build An App Without Interface Builder – Part 8: Progress'
date: 2015-11-20 10:04:59.000000000 +01:00
type: post
published: true
status: publish
categories:
- HowTo
- Interface Builder
tags:
- Interface Builder
- NSCalendar
- NSLayoutConstraint
- Progress
- UITableViewCell
---
It have been too long since my last post. Sorry about that. I'm really
busy right now. More on that in a few weeks, I guess. :)

In the [last
post](http://swiftandpainless.com/how-to-build-an-app-without-interface-builder-part-7-nicer-cell/)
we have added a pattern image to the birthday cell. In this post we will
make the progress the patter is showing reflecting the time left until
the person has birthday again.

Open `BirthdayCell.swift`
and add the following property:

{% highlight swift %}
var patternWidthConstraint: NSLayoutConstraint?
{% endhighlight %}

Next replace the hard coded trailing constraint with a dynamic
constraint:

{% highlight swift %}
// Replace this
layoutConstraints.append(patternView.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -150))

// with this
patternWidthConstraint = patternView.widthAnchor.constraintEqualToConstant(0)
layoutConstraints.append(patternWidthConstraint!)
{% endhighlight %}

<!--more-->
With this change we will be able to set the progress of the cell from
the controller using the constant of the trailing constraint. To
encapsulate the access to the constraint, add the following method to
`BirthdayCell`:

{% highlight swift %}
func updateProgress(progress: Float) {
  patternWidthConstraint?.constant = CGFloat(progress)*frame.size.width
}
{% endhighlight %}

The progress shown in the cell will reflect the days left until that
person has birthday normalized to the number of days in a year. To
calculate the remaining days we need a calendar with which we can
calculate the date components. Open `BirthdaysListDataProvider.swift`
and add the following properties:

{% highlight swift %}
private let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
var todayComponents: NSDateComponents?
var today: NSDate? {
  didSet {
    if let today = today {
      todayComponents = gregorian?.components([.Month, .Day, .Year], fromDate: today)
    }
  }
}
{% endhighlight %}

When ever `today` is set, its
date components are calculated and assigned to `todayComponents`.
This allows us to calculate the remaining days in percent until the date
of birthday. Add the following code to `tableView(_:cellForRowAtIndexPath:)`,
right before `return cell`:

{% highlight swift %}
let calculationComponents = birthday.birthday
if let today = today, todayComponents = todayComponents {
  if gregorian!.compareDate(today, toDate: birthday.birthday.date!, toUnitGranularity: [.Month, .Day]) == .OrderedDescending {
    calculationComponents.year = todayComponents.year + 1
  } else {
    calculationComponents.year = todayComponents.year + 1
    
  }
  
  let components = gregorian?.components([.Day], fromDateComponents: todayComponents, toDateComponents: calculationComponents, options: [])
  
  cell.updateProgress(1-Float(components!.day)/Float(365))
}
{% endhighlight %}

(Note: This is actually wrong. See the correction
[here](http://swiftandpainless.com/how-to-build-an-app-without-interface-builder-part-8-12-correction-and-future/).)

With this code, we first figure out if the next birthday of that person
will be this year or next year. Then we calculate the remaining days and
update the progress of the cell.

The last thing we have to do is to set `today` when ever the
view controller becomes visible. Open `BirthdaysListViewController`
and add the following method:

{% highlight swift %}
override func viewWillAppear(animated: Bool) {
  super.viewWillAppear(animated)
  dataProvider?.today = NSDate()
}
{% endhighlight %}

This is all we need to do to get the remaining time as progress shown in
the cells. Build an run. Add a few persons to the list. The result
should look like this:\
![]({{ site.baseurl }}/assets/Simulator-Screen-Shot-20.11.2015-09.29.48-200x300.png)

Wouldn't it be better if the list was ordered such that the next
birthday is at the top? Yes, it would!

Open `BirthdaysListDataProvider.swift`
and extract the code calculating the progress in a method:

{% highlight swift %}
func progressUntilBirthday(birthday: Birthday) -> Float? {
  let calculationComponents = birthday.birthday
  
  if let today = today, todayComponents = todayComponents, date = birthday.birthday.date {
    if gregorian!.compareDate(today, toDate: date, toUnitGranularity: [.Month, .Day]) == .OrderedDescending {
      calculationComponents.year = todayComponents.year + 1
    } else {
      calculationComponents.year = todayComponents.year + 1
    }
    
    let components = gregorian?.components([.Day], fromDateComponents: todayComponents, toDateComponents: calculationComponents, options: [])
    
    return 1.0-Float(components!.day)/Float(365)
  } else {
    return nil
  }
}
{% endhighlight %}

(Note: This is actually wrong. See the correction
[here](http://swiftandpainless.com/how-to-build-an-app-without-interface-builder-part-8-12-correction-and-future/).)

Now replace `tableView(_:cellForRowAtIndexPath:)`
with the following:

{% highlight swift %}
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer, forIndexPath: indexPath) as! BirthdayCell
  
  let birthday = birthdays[indexPath.row]
  cell.nameLabel.text = birthday.firstName
  cell.patternNameLabel.text = birthday.firstName
  cell.birthdayLabel.text = "\(birthday.birthday.day) \(birthday.birthday.month)"
  
  if let progress = progressUntilBirthday(birthday) {
    cell.updateProgress(progress)
  }
  
  return cell
}
{% endhighlight %}

As we have extracted the method that calculates the remaining days, we
can use it to sort the list. Replace the method `addBirthday(_:)`
with the following:

{% highlight swift %}
func addBirthday(birthday: Birthday) {
  birthdays.append(birthday)
  birthdays.sortInPlace { progressUntilBirthday($0) > progressUntilBirthday($1) }
}
{% endhighlight %}

With this change, we sort the birthdays list after we have added a new
person to the list. Build and run and add a few person to the list. You
should see something like this:

![]({{ site.baseurl }}/assets/Simulator-Screen-Shot-20.11.2015-09.55.54-200x300.png)

Nice. We are getting somewhere.

This is all for today. Let us hope it won't take that long for the next
post. Stay tuned.

You can find the current progress of the project on
[github](https://github.com/dasdom/Birthdays/tree/part8).

---
date: 2020-08-25 12:00
author: Dominik Hauser
tags: Storyboard, UITableView
---

# One App, Different Approaches: Interface Builder (Part One)

As an iOS developer you need to be able to build the user interface of your apps using different approaches.
Without using a third party library you can mainly choose between Storyboards, using code to build the user interface, and SwiftUI.
Each of these has it's advantages and disadvantages and each developer has a preference.

I think beginners should learn about these different approaches right from the start.
That's why I use all three in my book [Build Location-Bases Projects for iOS](https://pragprog.com/book/dhios/build-location-based-projects-for-ios).
I'm quite proud of it and I think you should check it out.

<img src="../../assets/2020-08-25/build_location_based_projects.jpg" width="40%"/>

In this and the next several blog posts I will show you how to build one app using these different approaches.
The app we build is a birthday countdown app.
You can add the birthdays of your loved ones and the app shows you the number of days until their next birthday.
It will look like this:

<img src="../../assets/2020-08-25/the_app.png" width="40%"/>

In this post we will use a Storyboard for the user interface.

> Note:   
> We will put all the screens in one Storyboard because it's a small and simple app.
> In a real app, you might want to split the user interface into several Storyboards.
> Let me know when you like to see a post about that in the future.

We want to concentrate on the differences in building the user interface.
Adding and storing the birthday data would distract from the main topic.
We will use a Swift package that I wrote for this blog mini series to hide how this works.

## Creating The Xcode Project

Open Xcode and create a new project using the shortcut ⌘⇧N.
Choose the Single View App template and click Next.
Type in the name BirthdaysIB, select the language Swift, select Storyboard for the User Interface and deselect the check boxes for Core Data, Include Unit Tests and Include UI Tests.
We won't write tests in this demo app and storing the data is manages by the Swift package we will include.

![](../../assets/2020-08-25/project_options.png)

Click Next, choose a location on your disk to store the project and click Create.

Next we add the package that will manage the birthday data.

## Adding The Swift Package

Select the Xcode menu item `File > Swift Packages > Add Package Dependency` and paste the package URL `https://github.com/dasdom/Birthdays` into the search field.
Click Next, click Next again and click Finish.
Xcode adds the package to the project.
Subsequently the project navigator should look like this:

![](../../assets/2020-08-25/project_navigator_after_adding_the_package.png)

## Creating The Birthday Countdown View

Now let's create the user interface that shows the remaining days until the next birthdays.
Click `Main.storyboard` to open it in the Interface Builder, show the library using the shortcut ⌘⇧L and drag a `UITableViewController` into the Storyboard.
Open the attributes inspector with the shortcut ⌥⌘5 and check the check box next to Is Initial View Controller.
Delete the View Controller Scene from the Storyboard.

> Note:   
> With all the enhancements in `UICollectionView` in iOS 13 and iOS 14 the user interface could easily be implemented using a collection view with compositional layout.
> In fact we will do that in the chapter in which we build this app without a storyboard.
> In this chapter we will use a `UITableView` because in a storyboard we can only use a collection view flow layout.

Open the library again and drag two labels into the table view cell of the table view.
Select both labels by clicking one of them and pressing the ⌘ key while you click the other one.
Then click the Embed button (the one with the arrow pointing into a box) in the lower right corner of the interface builder.
In the pop up window select Stack View:

![](../../assets/2020-08-25/embed_label_into_stackview.png)

Stack views are a very powerful tool to easily create complex layouts.
They layout their arranged views vertically or horizontally and you only have to configure a few variables.
See for example [UIStackViewPlayground](../uistackviewplayground/).

With the created stack view selected, open the attributes inspector using the shortcut ⌥⌘5.
Look for the setting with the name Spacing.
This value defines the spacing between the arranged sub views of the stack view.
Type in the value `10` and press return.
The Interface Builder reduces the size of the stack view such that it just large enough to embed its sub views respecting the set spacing.

Next we need to add layout constraints to define the position of the stack view within the table view cell.
Select the stack view and click the Add New Constraint button (the one with the square between the vertical lines) in the lower right of the Interface Builder.
Xcode opens a pop up window in which we can define the constraints we want to add.
Type in `0` into the four text fields in the upper third of the pop up and make sure the red markers are selected like shown in the following image:

![](../../assets/2020-08-25/stackview_constraints_in_cell.png)

Click Add 4 Constraints.
After adding the constraints, Interface Builder shows a red circle with a black arrow in the structure overview of the storyboard to indicate that there is a problem with the added layout constraints.

![](../../assets/2020-08-25/layout_error_in_cell.png)

Click the button to figure out, what the problem is.
The shown information is a bit confusing so let me explain what the problem is.
We haven't told the stack view exactly how it should layout its sub views.
We just told it that the spacing should be exactly 10 points.
But what should be the width of the labels?
And which of the labels should shrink if there is not enough space to show both?

We have to tell the stack view, or more precisely the layout system what to do.
The easiest way to solve this problem is to tell the layout system that the label on the right should pull its edges inward.
Select the right button, open the size inspector (⌥⌘6) and set the horizontal hugging priority to 252 as show in the following image:

![](../../assets/2020-08-25/hugging_priority_days_lable.png)

Subsequently the error indicator in the structure overview is gone.
Let's make the user interface a little bit more pleasing.
Select the left label, open the attributes inspector and change the font style to bold.

## Embedding in a Navigation Controller

The user should see what this app is about.
Let's embed the view controller into a navigation controller to add a navigation bar to put the title in.
This has the great advantage that we can put the button to add birthdays to the list there as well.

In the Interface Builder select the table view controller and click the Xcode menu item *Editor / Embed In / Navigation Controller*.
Next select the navigation bar of the added navigation controller and open the attribute inspector (⌥⌘5).
Check the check box at Prefers Large Titles.
Then click the navigation bar in the table view controller and type in the title "Birthdays".

Next we are going to add the source code for the birthday countdown list.

## BithdayCountdownViewController

First remove the file *ViewController.swift*.
Next use the shortcut ⌘N to add a new Cocoa Touch Class.
Type in the name `BirthdaysCountdownViewController` and make it the subclass of `UITableViewController`.
Make sure the check box at Also create XIB file is not selected and the language is set to Swift.
Click Next and the click Create.

The birthdays are managed by our Birthdays package so we need to import it into this file.
The package uses Combine to publish changes to the list of birthdays.
Add the following import statements to `BirthdaysCountdownViewController` below the existing import statement:

```swift
import Birthdays
import Combine
```

Next add the following property of a `BirthdaysManager` to `BirthdaysCountdownViewController`:

```swift
private let birthdaysManager = BirthdaysManager()
```
You don't need to understand how the `BirthdaysManager` works for this blog series.
You only need to know that you can add birthdays and subscribe to changes via Combine.

To be notified when something in the list of birthday countdowns changes, we need to subscribe to the corresponding Combine publisher.
Add the following property to `BirthdaysCountdownViewController`:

```swift
private var subscription: AnyCancellable?
```
We also need a property to hold the birthdayCountdowns to be shown in the table view.
Add the following property for and array of `BirthdayCountdown`s:

```swift
private var birthdayCountdowns: [BirthdayCountdown] = [] {
  didSet {
    self.tableView.reloadData()
  }
}
```

When ever the array with the birthday countdowns changes, we just reload the table view.
Usually you wouldn't reload the whole table view when only one of the entries changes but for the moment this is OK because adding new birthdays countdowns will we handled in another view.

To subscribe to changes add the following code at the end of `viewDidLoad()`:

```swift
subscription = birthdaysManager.$birthdayCounts
  .sink(receiveValue: { birthdayCounts in
    self.birthdayCountdowns = birthdayCounts
  })
```
With this code we subscribe to changes in the birthday counts array in the `Birthdays` package.

In the storyboard we added some label to the table view cell.
We also need a class for that table view cell to be able to connect the code of the cell with the cell in the storyboard.
Add a new Cocoa Touch Class to the project using the shortcut ⌘N, type in the name BirthdayCountdownCell and make it a subclass of `UITableViewCell`.
Remove the code in the created class.

Next we need to connect the storyboard with the code.
Open `Main.storyboard`, select the table view controller and open the identity inspector (⌥⌘4).
In the text field next to Class type in the name `BirthdaysCountdownViewController` and press return.

Then select the table view cell and set the class in the identity inspector to `BirthdayCountdownCell` and press return.
Open the attributes inspector with the shortcut ⌥⌘5 and type in the Identifier `BirthdayCountdownCell` and press return.

> Note:
> I always use the class name as the identifier of the table view cell.
> That way I have less to remember when returning back to the code.

In the storyboard click the table view cell until it is colored and open the assistant editor with the shortcut ⌃⌥⌘⏎.
Next select *BirthdayCountdownCell.swift* in the header bar of the editor:

![](../../assets/2020-08-25/cell_in_editor_header_bar.png)

Press and hold the control key and drag from the left label into the `BirthdayCountdownCell` class.
In the appearing pop-up window, type in the name `nameLabel` and make sure that Connection is set to Outlet:

![](../../assets/2020-08-25/name_label_outlet_config.png)

In the same way create an outlet for the right label with the name `countLabel`.

The cell shows the name of the person and the number of days until their next birthday.
Import the Birthdays module and add the following method that we will call from the table view controller to setup the cell with the data:

```swift
import UIKit
import Birthdays

class BirthdayCountdownCell: UITableViewCell {

  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var countLabel: UILabel!
  
  func update(with birthdayCount: BirthdayCountdown) {
    nameLabel.text = birthdayCount.name
    countLabel.text = "\(birthdayCount.remainingDays)"
  }
}
```

In this method we just set the name and the remaining days to the labels.
Nothing special here.

Next open *BirthdaysCountdownViewController.swift*, delete the method `numberOfSections(in:)` and replace the methods `tableView(_:numberOfRowsInSection:)` with the following code:

```swift
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  return birthdayCountdowns.count
}
```

With this code we tell the table view that it contains `birthdayCountdowns.count` cells.
Next, we have to tell the table view which cell it should use.
Add the following method to `BirthdaysCountdownViewController`:

```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
  let cell = tableView.dequeueReusableCell(withIdentifier: "BirthdayCountdownCell", for: indexPath) as! BirthdayCountdownCell
  
  let birthday = birthdayCountdowns[indexPath.row]
  cell.update(with: birthday)
  
  return cell
}
```

In this code, we ask the table view to dequeue a `BirthdayCountdownCell` and then call the `update(with:)` method to fill the cell with data.

Now let's test if the table view works.
Add the following code to `viewDidLoad()` of `BirthdaysCountdownViewController`:

```swift
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd"
if let date = dateFormatter.date(from: "2020-09-01") {
  birthdaysManager.add(Birthday(name: "Foo", date: date))
}
if let date = dateFormatter.date(from: "2020-10-01") {
  birthdaysManager.add(Birthday(name: "Bar", date: date))
}
```

Build and run the app on the iOS simulator.
You should see something like this:

<img src="../../assets/2020-08-25/result_with_demo_data.png" width="40%"/>

## Conclusion

The app is not finished yet but this blog post is already getting to long.
We will build the view on which the user can put in birthdays in the next blog post.

Let me know what you think about this blog post on Twitter: [@dasdom](https://twitter.com/dasdom).

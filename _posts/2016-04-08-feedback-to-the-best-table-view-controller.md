---
layout: post
title: Feedback to "The best table view controller"
date: 2016-04-08 14:05:32.000000000 +02:00
type: post
published: true
status: publish
categories:
- General
tags:
- best practice
- DRY
- feedback
- UITableViewCell
- UITableViewController
- update
---
I got some feedback to my last blog post about [The best table view
controller](http://swiftandpainless.com/the-best-table-view-controller-mar-2016-edition/).
In this post I want to comment on the feedback because the comment
sections is not really good for detailed discussion.

Storyboards
-----------

> I couldn’t get Interface Builder in Xcode 7.3 to support typed view
> controllers. While you can type in the associated class, the field
> becomes blank when the storyboard is saved.

Interesting. I wasn't aware of this. But this again tells me, that
storyboards (and the Interface Builder in general) are not suited for my
style of iOS development. As you may know, [I don't like the Interface
Builder](http://swiftandpainless.com/why-i-still-dont-like-the-interface-builder/).

If you depend on storyboards for your User Interface, than this kind of
table view controller isn't for you (yet).
<!--more-->

Multiple cells
--------------

> Tables with multiple cell types would be problematic.

That is correct. In my experience, kind of 90% of the table views I
build (during work and in my spare time) only have one cell type. In a
future post I might investigate how to do something similar with more
than one cell type. If you have an idea, please let me know.

Caching
-------

> There’s no way to cache or paginate date. Fine if the data set is
> small. More of a problem if you’re building the next Youtube.

This is not quite true. You can cache and paginate the date in the
subclass or even better in the network layer. The networking code I have
written for this demo project is quite simple. After watching the
[excellent
talk](https://realm.io/news/slug-marcus-zarra-exploring-mvcn-swift/) by
[Marcus Zarra](https://twitter.com/mzarra) I would rewrite the
networking to use NSOperation and some kind of caching mechanism. I'll
leave that for another post.

But why?
--------

> Hey Dominik, a noob question over here: why do you want to subclass
> uitableviewcontroller the way you did in your article? What are the
> advantages?

This is a big question here. Table views are so common in iOS
development that I didn't think about that many beginners might have
problems to see why this might be a good (or a bad) idea. Instead of
convincing beginners, that my approach is better than another approach,
I will compare it to the way I wrote my table view controller code for a
very long time.

Here is the `UserSerachTableViewController` as I would have implemented years ago:

{% highlight swift %}
import UIKit

class TraditionalUserSerachTableViewController: UITableViewController, UISearchBarDelegate {
  
  var users = [User]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "User"
    
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
    searchBar.placeholder = "Github username"
    searchBar.delegate = self
    tableView.tableHeaderView = searchBar
    
    tableView.registerClass(TwoLabelCell.self, forCellReuseIdentifier: "Cell")
    
    tableView.estimatedRowHeight = 50
    tableView.rowHeight = UITableViewAutomaticDimension
  }
}

// MARK: - UITableViewDataSource
extension TraditionalUserSerachTableViewController {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  
    let user = users[indexPath.row]
    
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TwoLabelCell
    cell.nameLabel.text = user.name
    return cell
  }
}

//MARK - UITableViewDelegate
extension TraditionalUserSerachTableViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let next = TraditionalRepositoriesTableViewController()
    next.username = self.users[indexPath.row].name
    navigationController?.pushViewController(next, animated: true)
  }
}

//MARK: - UISearchBarDelegate
extension TraditionalUserSerachTableViewController {
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    guard let searchString = searchBar.text where searchString.characters.count > 0 else { return }
    let fetch = APIClient<User>().fetchUsers(forSearchString: searchString)
    fetch { (items, error) -> Void in
      guard let theItems = items else { return }
      self.users = theItems
      self.tableView.reloadData()
    }
  }
}
{% endhighlight %}

Let's go through this step-by-step. `viewDidLoad()` looks similar to my currently favorite version. The only difference is that we
have to add these calls:

{% highlight swift %}
tableView.registerClass(TwoLabelCell.self, forCellReuseIdentifier: "Cell")
    
tableView.estimatedRowHeight = 50
tableView.rowHeight = UITableViewAutomaticDimension
{% endhighlight %}

Ok, not that bad. Next are the required method in the protocol `UITableViewDataSource`. 
We need to implement those because `TraditionalUserSerachTableViewController` is a subclass 
of `UITableViewController` and that conforms to `UITableViewControllerDataSource`.
They look like this:

{% highlight swift %}
// MARK: - UITableViewDataSource
extension TraditionalUserSerachTableViewController {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  
    let user = users[indexPath.row]
    
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TwoLabelCell
    cell.nameLabel.text = user.name
    return cell
  }
}
{% endhighlight %}

Still, very easy. In my currently preferred way those methods are
implemented in the base class `TableViewController`
and therefore they don't need to be implemented in the subclasses
because they inherit the implementations. We will see later, why this
might be a good idea.

Next, when the user taps a table view cell, the view controller showing
the repositories should be pushed onto the navigation stack. This is the
same as in the way I showed in the last blog post:

{% highlight swift %}
//MARK - UITableViewDelegate
extension TraditionalUserSerachTableViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let next = TraditionalRepositoriesTableViewController()
    next.username = self.users[indexPath.row].name
    navigationController?.pushViewController(next, animated: true)
  }
}
{% endhighlight %}

Nothing to explain here, I think (if you have questions, feel free to
write a comment and I'll explain further).

Finally the method that reacts on search requests by the user:

{% highlight swift %}
//MARK: - UISearchBarDelegate
extension TraditionalUserSerachTableViewController {
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    guard let searchString = searchBar.text where searchString.characters.count > 0 else { return }
    let fetch = APIClient<User>().fetchUsers(forSearchString: searchString)
    fetch { (items, error) -> Void in
      guard let theItems = items else { return }
      self.users = theItems
      self.tableView.reloadData()
    }
  }
}
{% endhighlight %}

In contrast to the version from the last blog post, the network request
is in the delegate method of the search bar rather than in `didSet` of the
searchString property. The latter has the advantage that, when ever the
searchString changes, a network request is executed. Therefore we only
need the network code at one place. In this case it doesn't matter
because there is only one location in the code that talks to the
network.

So in a direct comparison, my currently favorite method to build table
view controllers doesn't look as an advantage over the method I used
years ago. The interesting part appears, when you have more than one
table view controller. Than the approach with the base class wins, in my
opinion, because a lot of the boiler plate code is the same or similar
for all the table view controllers. Let's have a look what the
repository table view controller in the 'traditional' way would look
like:

{% highlight swift %}
import UIKit

class TraditionalRepositoriesTableViewController: UITableViewController {
  
  var username: String?
  var repositories = [Repository]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let username = username where username.characters.count > 0 else { return }
    let fetch = APIClient<Repository>().fetchItems(forUser: username)
    fetch { (items, error) -> Void in
      self.title = username
      guard let theItems = items else { return }
      self.repositories = theItems
      self.tableView.reloadData()
    }
    
    tableView.registerClass(TwoLabelCell.self, forCellReuseIdentifier: "Cell")
    
    tableView.estimatedRowHeight = 50
    tableView.rowHeight = UITableViewAutomaticDimension
  }
}

// MARK: - UITableViewDataSource
extension TraditionalRepositoriesTableViewController {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repositories.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let repository = repositories[indexPath.row]
    
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TwoLabelCell
    cell.nameLabel.text = repository.name
    cell.descriptionLabel.text = repository.description
    return cell
  }
}

//MARK - UITableViewDelegate
extension TraditionalRepositoriesTableViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let nextViewController = DetailViewController()
    nextViewController.repository = repositories[indexPath.row]
    navigationController?.pushViewController(nextViewController, animated: true)
  }
}
{% endhighlight %}

Again, this is not complicated and to write the code like that is
totally fine. But if you have a closer look at `viewDidLoad()`, `tableView( :numberOfRowsInSection:)` 
and `tableView( :cellForRowAtIndexPath:)`, they look quite similar to the
implementation in `TraditionalUserSerachTableViewController`.
An important principle in software development is:

> Don't Repeat Yourself (DRY)

This means, when ever you see code in your project that looks similar to
other code in the same project, try to find a way to put that similarity
into another class or struct or function to reduce doubling.

And that's why I think the approach I have shown in [the previous blog
post](http://swiftandpainless.com/the-best-table-view-controller-mar-2016-edition/)
is a good approach. It reduces doubling of code. And at the same time is
quite easy to read, understand and maintain. Don't be clever with your
code. Be as simple and boring as you can.

I have added the 'traditional' code to the [repository on
github](https://github.com/dasdom/TableViewMarch2016).

If you have some feedback or questions, please write a comment or
contact me on Twitter.

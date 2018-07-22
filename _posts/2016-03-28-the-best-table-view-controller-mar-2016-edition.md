---
layout: post
title: The best table view controller (Mar 2016 edition)
date: 2016-03-28 21:01:10.000000000 +02:00
type: post
published: true
status: publish
categories:
- General
tags:
- Generics
- Lighter View Controller
- protocol
- Swift
- UITableViewController
---
Since I read the [objc.io post about light view
controller](https://www.objc.io/issues/1-view-controllers/lighter-view-controllers/),
every few month I come back to the same problem: find the best way to
write a table view controller. I have tried several different approaches
like putting the data source and delegate in a separate class or using
MVVM to populate the cell.

This post is the March 2016 solution to this problem. And as most of the
times, I'm quite happy with the current solution. It uses generics,
protocols and value types.

The main part is the base table view controller. It holds the array to
store the model data, is responsible for registering the cell class and
it implements the needed table view data source methods.

Let's start with the class declaration:

{% highlight swift %}
import UIKit

class TableViewController<T, Cell: UITableViewCell where Cell: Configurable>: UITableViewController {

}
{% endhighlight %}
<!--more-->

The base table view controller is a generic subclass of `UITableViewController`.
The placeholder type name `Cell` is of type `UITableViewCell` and
conforms to the protocol `Configurable`. The
protocol is very simple. It just defines one method:

{% highlight swift %}
import Foundation

protocol Configurable {
  func config(withItem item: Any)
}
{% endhighlight %}

The cell will be registered and dequeued in the `TableViewController`.
This means it is enough to have a private property for the cell
identifier:

{% highlight swift %}
private let cellIdentifier = String(Cell)
{% endhighlight %}

Next we need an array to hold the data to be presented in the table
view:

{% highlight swift %}
var data = [T]() {
  didSet {
    tableView.reloadData()
    if tableView.numberOfRowsInSection(0) > 0 {
      tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0,inSection: 0),
                                       atScrollPosition: .Top,
                                       animated: true)
    }
  }
}
{% endhighlight %}

Whenever the data is set, `reloadData()` of the
table view is called and the table view is scrolled to top. Next, we
define an init method:

{% highlight swift %}
init() { super.init(nibName: nil, bundle: nil) }
{% endhighlight %}

In `viewDidLoad()` we set up the table view:

{% highlight swift %}
override func viewDidLoad() {
  super.viewDidLoad()
  tableView.registerClass(Cell.self, forCellReuseIdentifier: cellIdentifier)
  tableView.rowHeight = UITableViewAutomaticDimension
  tableView.estimatedRowHeight = 60
}
{% endhighlight %}

What's left is to provide the required method if `UITableViewDataSource`:

{% highlight swift %}
override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  return data.count
}

override func tableView(tableView: UITableView,
                        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
                                                         forIndexPath: indexPath) as! Cell
  cell.config(withItem: data[indexPath.row])
  return cell
}
{% endhighlight %}

The only interesting part of these methods is the line 
`cell.config(withItem: data[indexPath.row])`. This means the cell is responsible to
fill it's labels or what ever the cell uses to present the data.

Here is the complete base table view controller class:

{% highlight swift %}
import UIKit

class TableViewController<T, Cell: UITableViewCell where Cell: Configurable>: UITableViewController {
  
  private let cellIdentifier = String(Cell)
  var data = [T]() {
    didSet {
      tableView.reloadData()
      if tableView.numberOfRowsInSection(0) > 0 {
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0,inSection: 0),
                                         atScrollPosition: .Top,
                                         animated: true)
      }
    }
  }
  
  init() { super.init(nibName: nil, bundle: nil) }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerClass(Cell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 60
  }
  
  // MARK: - Table view data source
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  override func tableView(tableView: UITableView,
                          cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
                                                           forIndexPath: indexPath) as! Cell
    cell.config(withItem: data[indexPath.row])
    return cell
  }
}
{% endhighlight %}

We can use this base class to define a table view controller that let's
the user put in a string and search on Github for matching users:

{% highlight swift %}
class UserSearchTableViewController<T: protocol<DictCreatable, LabelsPresentable, UserProtocol>>: TableViewController<T, TwoLabelCell>, UISearchBarDelegate {

  var searchString: String? {
    didSet {
      guard let searchString = searchString where searchString.characters.count > 0 else { return }
      let fetch = APIClient<T>().fetchUsers(forSearchString: searchString)
      fetch { (items, error) -> Void in
        guard let theItems = items else { return }
        self.data = theItems.map { $0 }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "User"
    
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
    searchBar.placeholder = "Github username"
    searchBar.delegate = self
    tableView.tableHeaderView = searchBar
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchString = searchBar.text
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let next = RepositoriesTableViewController<Repository>()
    next.username = self.data[indexPath.row].name
    navigationController?.pushViewController(next, animated: true)
    
  }
}
{% endhighlight %}

That is a complete table view controller. Most of the code is for the
presentation and handling of the searchBar. Neat, isn't it?

With all this, an instance of `UserSearchTableViewController`
can be initialized like this:

{% highlight swift %}
let viewController = UserSearchTableViewController<User>()
{% endhighlight %}

For completeness, here is a possible version of `TwoLabelCell`:

{% highlight swift %}
import UIKit

class TwoLabelCell: UITableViewCell, Configurable {

  let nameLabel: UILabel
  let descriptionLabel: UILabel
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    nameLabel = UILabel()
    nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    
    descriptionLabel = UILabel()
    descriptionLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    descriptionLabel.numberOfLines = 2
    
    let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .Vertical
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubview(stackView)
    
    let views = ["stackView": stackView]
    var layoutConstraints = [NSLayoutConstraint]()
    layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("|-[stackView]-|", options: [], metrics: nil, views: views)
    layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[stackView]-|", options: [], metrics: nil, views: views)
    NSLayoutConstraint.activateConstraints(layoutConstraints)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func config(withItem item: Any) {
    guard let item = item as? LabelsPresentable else { return }
    let texts = item.texts
    if texts.count > 0 {
      nameLabel.text = texts[0]
    }
    if texts.count > 1 && texts[1].characters.count > 0 {
      descriptionLabel.text = texts[1]
    }
  }
}
{% endhighlight %}

You can find the code and another table view controller using the same
structure on [Github](https://github.com/dasdom/TableViewMarch2016).

Update April 1st 2016: Improved the code after a discussion about it in
the Swiftde-Slack group.

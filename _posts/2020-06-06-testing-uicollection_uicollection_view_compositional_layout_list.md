---
layout: post
date: 2020-06-06
author: Dominik Hauser
categories: UICollectionView, UICollectionViewCompositionalLayout
title: "Testing a Custom UICollectionViewCompositionalLayout.list"
---

In iOS 14 Apple added a collection view compositional layout that lets us create collection views that look and behave like `UITableView`s.
It is based on UICollectionViewCompositionalLayout and as a result allows to create very complex collection view layouts with only little code.

I believe that we should test our view controllers.
For example I often write tests that assure that setting up a table view cell works as intended.
An example for such a test looks like this:

{% highlight swift %}
func test_cellForRow_populatesCell() {
  // given
  sut.names = ["foo"]
  
  // when
  let indexPath = IndexPath(row: 0, section: 0)
  let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
  
  // then
  XCTAssertEqual(cell?.textLabel?.text, sut.names.first)
}
{% endhighlight %}

(This code is taken from my book [Test-Driven iOS Development - Gimme The Code](https://leanpub.com/tdd_ios_gimme_the_code)).

Testing the population of a table view cell is quite easy.
We setup the data source, get the cell from it and assert that the relevant data is set to the label in the cell.

The list layout in `UICollectionViewCompositionalLayout` works quite differently.
I don't want to go into detail in this post how you can setup a collection view with the new list layout.
Let's safe that for a later post.
All you need to know is that you setup a `UICellConfigurationState` and tell the cell that it needs to update it's configuration.
The cell then calls the method `updateConfiguration(using:)` and you override that method to setup the cell.

You can see how this works in `CustomCellListViewController.swift` in the sample code provided by Apple [here](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views).

When I tried to write a test for this, I ran into the problem that `updateConfiguration(using:)` is called after my test is finished.
~~So it looks like to me that UIKit postpones the call onto the next run loop.
This means to be able to test the population of the collection view cell, I needed move the assertion to the next run loop as well.~~
The Apple engineer [@_mochs](https://twitter.com/_mochs) answered to my posts, that it should be sufficient to call `layoutIfNeeded` on the cell to trigger populating the cell.

So, this works:

{% highlight swift %}
func test_cellForItem_returnsConfiguresCell() {
    let item = Item(category: .music, title: "Foo", description: "Bar")
    sut.items = [item]
    sut.loadViewIfNeeded()

    let indexPath = IndexPath(item: 0, section: 0)
    let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath) as! CustomListCell

    let listContentConfiguration = cell.listContentView.configuration as! UIListContentConfiguration
    XCTAssertEqual(listContentConfiguration.text, item.title)
}
{% endhighlight %}

By the way, this is a test for the sample code provided by Apple.
I've added tests to better understand what's going on.

Do you know a better way to test this?
How would you test that the collection view cell in the list layout is populated properly?

If you have questions or remarks about this post, please let me know on Twitter: [@dasdom](https://twitter.com/dasdom).

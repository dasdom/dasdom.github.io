---
layout: post
title: An Easy Way To Stub NSURLSession
date: 2016-01-09 14:57:27.000000000 +01:00
type: post
published: true
status: publish
categories:
- TDD
tags:
- NSURLSession
- Stubbing
- Testing
- Unit Tests
---
If you follow this blog for some time you might have realized that one
of my favorite testing problems is the stubbing of `NSURLSession`.

In case you are not familiar with the terms, stubbing means to fake the
answer of a method. In the case of `NSURLSession` this means that we fake
the web API response. This has several advantages. For example:

1.  We don't need a working web API to developer the network requests of
    our app.
2.  The response is instantaneous. This results in a faster
    feedback loop.
3.  The tests can run on a computer that has no internet connection.

Normally the stubbing of `NSURLSession` requests is done using
`NSURLProtocol`. Libs doing that are for example
[OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs) and
[Mockingjay](https://github.com/kylef/Mockingjay). The advantage of
using `NSURLProtocol` is, that the stubbing also works when using libs as
[Alamofire](https://github.com/Alamofire/Alamofire) for the network
requests. This works great but for me this is to much code. I would have
to study and understand that code to get the desired confidence im my
tests.
<!--more-->

An easy solution
----------------

I use `NSURLSession` for my network requests. Here is how I stub my
requests.

To make it easier, I have written a mock class for `NSURLSession` and a
protocol. All that together looks like this:

{% highlight swift %}
import Foundation

public protocol DHURLSession {
  func dataTaskWithURL(url: NSURL,
    completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask
  func dataTaskWithRequest(request: NSURLRequest,
    completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask
}

extension NSURLSession: DHURLSession { }

public final class URLSessionMock : DHURLSession {
  
  var url: NSURL?
  var request: NSURLRequest?
  private let dataTaskMock: URLSessionDataTaskMock
  
  public init(data: NSData?, response: NSURLResponse?, error: NSError?) {
    dataTaskMock = URLSessionDataTaskMock()
    dataTaskMock.taskResponse = (data, response, error)
  }
  
  public func dataTaskWithURL(url: NSURL,
    completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
      self.url = url
      self.dataTaskMock.completionHandler = completionHandler
      return self.dataTaskMock
  }
  
  public func dataTaskWithRequest(request: NSURLRequest,
    completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
      self.request = request
      self.dataTaskMock.completionHandler = completionHandler
      return self.dataTaskMock
  }
  
  final private class URLSessionDataTaskMock : NSURLSessionDataTask {
    
    typealias CompletionHandler = (NSData!, NSURLResponse!, NSError!) -> Void
    var completionHandler: CompletionHandler?
    var taskResponse: (NSData?, NSURLResponse?, NSError?)?
    
    override func resume() {
      completionHandler?(taskResponse?.0, taskResponse?.1, taskResponse?.2)
    }
  }
}
{% endhighlight %}

So, the complete helper code I need to write my stubs is 47 lines of
code. And all that code is easy to understand. No swizzling, not
complicated methods. Nice!

The usage
---------

To be able to use the `NSURLSession` mock in the test, we need a way to
inject the dependency into the code. One possibility is the usage of a
lazy property:

{% highlight swift %}
lazy var session: DHURLSession = NSURLSession.sharedSession()
{% endhighlight %}

Then an example test would look like this:

{% highlight swift %}
func testFetchingProfile_ReturnsPopulatedUser() {
  // Arrage
  let responseString = "{\"login\": \"dasdom\", \"id\": 1234567}"
  let responseData = responseString.dataUsingEncoding(NSUTF8StringEncoding)!
  let sessionMock = URLSessionMock(data: responseData, response: nil, error: nil)
  let apiClient = APIClient()
  apiClient.session = sessionMock
  
  // Act
  apiClient.fetchProfileWithName("dasdom")
  
  // Assert
  let user = apiClient.user
  let expectedUser = User(name: "dasdom", id: 1234567)
  XCTAssertEqual(user, expectedUser)
}
{% endhighlight %}

I really like this approach because I can understand the mocking within
a few minutes by scanning over 50 lines of code. There is no
`NSURLProtocol` and not swizzling involved.

The `NSURLSession` mock is on
[github](https://github.com/dasdom/DHURLSessionStub) and it's also
available via CocoaPods.

Let me know what you think.

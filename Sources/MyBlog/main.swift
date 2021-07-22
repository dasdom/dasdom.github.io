import Foundation
import Publish
import Plot
import SplashPublishPlugin

// This type acts as the configuration for your website.
struct MyBlog: Website {
  enum SectionID: String, WebsiteSectionID {
    // Add the sections that you want your website to contain here:
    case posts
    case books
    case about
    case imprint
    case privacy
  }
  
  struct ItemMetadata: WebsiteItemMetadata {
    // Add any site-specific metadata that you want to use here.
  }
  
  // Update these properties to configure your website:
  var url = URL(string: "https://dasdom.dev")!
  var name = "dasdom"
  var description = "Articles about TDD, Xcode, iOS, Swift, ObjC and stuff by Dominik Hauser."
  var language: Language { .english }
  var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try MyBlog().publish(withTheme: .simple,
                     deployedUsing: .gitHub("dasdom/dasdom.github.io", useSSH: false),
                     additionalSteps: [
  .addMarkdownFiles(at: "Content/pages"),
  ],
  plugins: [.splash(withClassPrefix: "")]
)

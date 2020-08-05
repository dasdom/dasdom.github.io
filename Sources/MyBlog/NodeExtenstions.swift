//  Created by dasdom on 19.07.20.
//  Based on Foundation theme by John Sundell
//

import Publish
import Plot
import Foundation

extension Node where Context == HTML.BodyContext {
  static func wrapper(_ nodes: Node...) -> Node {
    .div(.class("wrapper"), .group(nodes))
  }
  
  static func header<T: Website>(
    for context: PublishingContext<T>,
    selectedSection: T.SectionID?
  ) -> Node {
    
    let sectionIDs = T.SectionID.allCases
    
    
    return .header(
      .wrapper(
        .a(
          .class("site-name"),
          .href("/"),
          .text(context.site.name)
        ), //a
        .if(sectionIDs.count > 1,
            .nav(
              .ul(
                .forEach(sectionIDs) { section in
                  .li(
                    .a(
                      .class(section == selectedSection ? "selected" : ""),
                      .href(context.sections[section].path),
                      .text(context.sections[section].title)
                    ) //a
                  ) //li
                } //forEach
              ) //ul
          ) //nav
        ) //if
      )
    )
  }
  
  static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
   
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .medium
    
    return .ul(
      .class("item-list"),
      .forEach(items) { item in
        .li(.article(
          .p(
            .text(dateFormatter.string(from: item.date))
            ),
          .h1(.a(
            .href(item.path),
            .text(item.title)
            )),
          .tagList(for: item, on: site),
          .p(.text(item.description))
          ))
      }
    )
  }
  
  static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
    return .ul(.class("tag-list"), .forEach(item.tags) { tag in
      .li(.a(
        .href(site.path(for: tag)),
        .text(tag.string)
        ))
      })
  }
  
  static func footer<T: Website>(for site: T) -> Node {
    return .footer(
      .p(
        .text("Generated using "),
        .a(
          .text("Publish"),
          .href("https://github.com/johnsundell/publish")
        )
      ),
      .p(
        .a(
        .text("RSS feed"),
        .href("/feed.rss")
        ),
        .a(
          .text(" | ")
        ),
        .a(
          .text("Twitter"),
          .href("https://twitter.com/dasdom")
        ),
        .a(
          .text(" | ")
        ),
        .a(
          .text("StackOverflow"),
          .href("https://stackoverflow.com/users/498796/dasdom")
        ),
        .a(
          .text(" | ")
        ),
        .a(
          .text("Github"),
          .href("https://github.com/dasdom")
        ),
        .a(
          .text(" | ")
        ),
        .a(
          .text("My Book"),
          .href("https://pragprog.com/titles/dhios/")
        )
      )
    )
  }
}

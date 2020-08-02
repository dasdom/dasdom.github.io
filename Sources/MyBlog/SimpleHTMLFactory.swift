//  Created by dasdom on 19.07.20.
//  
//

import Publish
import Plot
import Foundation

struct SimpleHTMLFactory<Site: Website>: HTMLFactory {
  
  func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
    HTML(
      .head(for: index, on: context.site),
      .body(
        .header(for: context, selectedSection: nil),
        .wrapper(
          .h1(.text(index.title)),
          .p(
            .class("description"),
            .text(context.site.description)
          ), //p
          .h2("Latest content"),
          .itemList(
            for: context.allItems(sortedBy: \.date, order: .descending),
            on: context.site
          ) //itemList
        ), //wrapper
        .footer(for: context.site)
      ) //body
    ) //HTML
  }
  
  func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
    HTML(
        .lang(context.site.language),
        .head(for: section, on: context.site),
        .body(
            .header(for: context, selectedSection: section.id),
            .wrapper(
                .h1(.text(section.title)),
                .itemList(for: section.items, on: context.site)
            ), //wrapper
            .footer(for: context.site)
        ) //body
    ) //HTML
  }
  
  func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .medium
    return HTML(
        .head(for: item, on: context.site),
        .body(
            .class("item-page"),
            .header(for: context, selectedSection: item.sectionID),
            .wrapper(
              .p(
                .text(dateFormatter.string(from: item.content.date))
                ),
                .article(
                    .div(
                        .class("content"),
                        .contentBody(item.body)
                    ),
                    .span("Tagged with: "),
                    .tagList(for: item, on: context.site)
                )
            ),
            .footer(for: context.site)
        )
    ) //HTML
  }
  
  func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
    HTML(
        .head(for: page, on: context.site),
        .body(
          .header(for: context, selectedSection: nil),
            .wrapper(.contentBody(page.body)),
            .footer(for: context.site)
        )
    ) //HTML
  }
  
  func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
    HTML(
        .lang(context.site.language),
        .head(for: page, on: context.site),
        .body(
            .header(for: context, selectedSection: nil),
            .wrapper(
                .h1("Browse all tags"),
                .ul(
                    .class("all-tags"),
                    .forEach(page.tags.sorted()) { tag in
                        .li(
                            .class("tag"),
                            .a(
                                .href(context.site.path(for: tag)),
                                .text(tag.string)
                            )
                        )
                    }
                )
            ),
            .footer(for: context.site)
        )
    ) //HTML
  }
  
  func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
    HTML(
        .lang(context.site.language),
        .head(for: page, on: context.site),
        .body(
            .header(for: context, selectedSection: nil),
            .wrapper(
                .h1(
                    "Tagged with ",
                    .span(.class("tag"), .text(page.tag.string))
                ),
                .a(
                    .class("browse-all"),
                    .text("Browse all tags"),
                    .href(context.site.tagListPath)
                ),
                .itemList(
                    for: context.items(
                        taggedWith: page.tag,
                        sortedBy: \.date,
                        order: .descending
                    ),
                    on: context.site
                )
            ),
            .footer(for: context.site)
        )
    ) //HTML
  }
  
  
}

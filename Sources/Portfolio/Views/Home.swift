import Foundation
import WebUI

struct Home: HTML {
  let articles: [ArticleResponse]

  init(articles: [ArticleResponse] = []) {
    self.articles = articles.sorted {
      guard let date1 = $0.publishedDate, let date2 = $1.publishedDate else { return false }
      return date1 > date2
    }
  }

  func render() -> String {
    Layout {
      Heading(level: .one) { "Software engineer, skater, & musician." }
        .styled(size: .xl4)
        .margins(.bottom)
      Text {
        "I'm Mac, a software engineer based out of the United Kingdom. I enjoy building robust and efficient software. Read some of my articles below."
      }.font(family: "ui-serif")

      if !articles.isEmpty {
        Stack {
          for article in articles {
            Link(to: "/articles/\(article.id)") {
              Article {
                Heading(level: .two) { article.title }.styled(size: .lg)
                Time(datetime: "\(article.publishedDate?.ISO8601Format() ?? "")") {
                  "\(article.publishedDate?.formatted(date: .complete, time: .omitted) ?? "")"
                }
                .font(size: .sm, color: .zinc(._600, opacity: 0.9))
                .font(color: .zinc(._400, opacity: 0.9), on: .dark)
                Text {
                  article.description
                }
                .font(size: .sm, family: "ui-serif")
                .margins(.top, length: 2)
                .margins(.bottom, length: 3)
                Text { "Read more ›" }
                  .font(size: .sm, weight: .semibold, color: .teal(._500))
              }
              .cursor(.pointer)
              .flex(direction: .column, align: .start)
              .border(edges: .all, radius: (side: .all, size: .lg))
              .background(color: .zinc(._300), on: .hover)
              .background(color: .zinc(._700), on: .hover, .dark)
              .transition(property: .colors, duration: 300, easing: .inOut)
              .padding()
            }
          }
        }.flex(direction: .column).padding(length: 10).spaced()
      } else {
        Text {
          "No articles available at the moment. Check back soon!"
        }.padding().margins(.top)
      }
    }.render()
  }
}

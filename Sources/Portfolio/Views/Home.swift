import Foundation
import WebUI

struct Home: HTML {
  let articles: [ArticleResponse]

  init(articles: [ArticleResponse] = []) {
    self.articles = articles
  }

  func render() -> String {
    Layout {
      Heading(level: .one) { "Software engineer, skater, & musician." }.styled(size: .xl4).margins(.bottom)
      Text {
        "I'm Mac, a software engineer based out of the United Kingdom. I enjoy building robust and efficient software. Read some of my articles below."
      }.font(family: "ui-serif")

      if !articles.isEmpty {
        Stack {
          for article in articles {
            Anchor(to: "/portfolio/articles/\(article.id)") {
              Article {
                Heading(level: .two) { article.title }.styled(size: .lg)
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
              .background(color: .zinc(._700), on: .hover)
              .transition(property: .colors, duration: 300, easing: .inOut)
              .padding()
            }
          }
        }.flex(direction: .column).spaced()
      } else {
        Text {
          "No articles available at the moment. Check back soon!"
        }.font(family: "ui-serif").margins(.top)
      }
    }.render()
  }
}

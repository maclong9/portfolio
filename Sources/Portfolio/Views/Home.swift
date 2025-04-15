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
        "I'm Mac, a software engineer based out of the United Kingdom. I enjoy working on open source projects and building things that make people's lives easier. Read some of my articles below."
      }.font(family: "ui-serif")

      // Only show the articles section if there are articles
      if !articles.isEmpty {
        Stack {
          // Iterate through all articles
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
        // Show a message if no articles are available
        Text {
          "No articles available at the moment. Check back soon!"
        }.font(family: "ui-serif").margins(.top)
      }
    }.render()
  }
}

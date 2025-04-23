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
      
      Stack {
        for article in articles {
          Card(
            title: article.title,
            url: "/articles/\(article.id)",
            description: article.description,
            technologies: nil,
            publishedDate: article.publishedDate
          )
        }
      }.flex(direction: .column).padding(length: 10).margins(.vertical)
    }.render()
  }
}

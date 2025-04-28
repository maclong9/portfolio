import Foundation
import WebUI

struct Home: HTML {
  let articles: [ArticleResponse]
  var document: Document {
    .init(
      path: "index",
      metadata: .init(
        site: Portfolio.author,
        title: "Home",
        description: "Software Engineer, crafting intuitive solutions.",
        image: "/public/og.jpg",
        author: Portfolio.author,
        type: .website,
        themeColor: .init(light: "oklch(92% 0.004 286.32)", dark: "oklch(14.1% 0.005 285.823)")
      ),
      head: "<link rel=\"icon\" href=\"/public/icon.svg\" type=\"image/svg+xml\" />",
      content: { self },
    )
  }

  init(articles: [ArticleResponse] = []) {
    self.articles = articles.sorted {
      guard let date1 = $0.publishedDate, let date2 = $1.publishedDate else { return false }
      return date1 > date2
    }
  }

  func render() -> String {
    Layout(
      title: "Software engineer, skater, & musician.",
      description:
        "I'm Mac, a software engineer based out of the United Kingdom. I enjoy building robust and efficient software. Read some of my articles below.",
    ) {
      Collection(items: articles)
    }.render()
  }
}

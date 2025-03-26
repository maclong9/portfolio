import Foundation
import WebUI

struct Articles: HTML {
  let articles: [ArticleData] = [
    .init(
      date: Date(), title: "Hello, World!", description: "My first post.", image: "/articles/example.png",
      content: ExampleArticle()
    ),
    .init(
      date: Date(), title: "Hello, Moon!", description: "My moon post.", image: "/articles/example.png",
      content: MoonArticle()
    ),
  ]

  func render() -> String {
    RootLayout {
      Hero(
        heading: "Writing on software, productivity, and personal growth",
        text:
          "All of my long-form thoughts on programming, leadership, product design, and more, collected in chronological order."
      )
      Section {
        ArticlesList()
      }
    }.render()
  }
}

struct ArticlesList: HTML {
  func render() -> String {
    List {
      for article in Articles().articles {
        Card(
          title: article.title,
          description: article.description,
          date: article.date,
          url: article.image
        )
      }
    }.render()
  }
}

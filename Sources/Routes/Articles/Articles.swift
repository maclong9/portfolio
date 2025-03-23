import Foundation
import WebUI

@MainActor let articles: [ArticleData] = [
  .init(
    date: Date(), title: "Hello, World!", description: "My first post.", image: "/articles/example.png",
    content: ExampleArticle()
  ),
  .init(
    date: Date(), title: "Hello, Moon!", description: "My moon post.", image: "/articles/example.png",
    content: MoonArticle()
  ),
]

struct Articles: HTML {
  func render() -> String {
    RootLayout {
      Hero(
        heading: "Writing on software, productivity, and personal growth",
        text:
          "All of my long-form thoughts on programming, leadership, product design, and more, collected in chronological order."
      )
      Section {
        List {
          // for loop of articles
        }
      }
    }.render()
  }
}

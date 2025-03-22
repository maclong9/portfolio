import Foundation
import WebUI

struct ArticleData {
  let date: Date
  let title: String
  let description: String
  let image: String
  let content: HTML
}

public struct ArticleLayout: HTML {
  let date: Date
  let title: String
  let description: String
  let image: String

  let children: [any HTML]

  public init(
    date: Date,
    title: String,
    description: String,
    image: String,
    @HTMLBuilder children: @escaping () -> [any HTML]
  ) {
    self.date = date
    self.title = title
    self.description = description
    self.image = image
    self.children = children()
  }

  public func render() -> String {
    Article {
      Header {
        Time(datetime: date.formatted()) { date.formatted() }
        Heading(level: .one) { title }
        Text { description }
        Image(sources: [image], description: "\(title) cover")
      }

      Main {
        children.map { $0.render() }.joined()
      }

      Footer {
        Stack {
          Avatar()
          Text { "Mac Long" }
        }
        Link(to: "/articles") { "Read more" }
      }
    }.render()
  }
}

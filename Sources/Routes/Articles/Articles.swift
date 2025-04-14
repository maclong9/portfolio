import Foundation
import WebUI

struct ArticleData {
  let slug: String
  let title: String
  let description: String
  let date: Date
  let content: any HTML

  init(slug: String, title: String, description: String, date: String, content: any HTML) {
    self.slug = slug
    self.title = title
    self.description = description
    let formatter = ISO8601DateFormatter()
    self.date = formatter.date(from: date) ?? Date()
    self.content = content
  }
}

func createArticleDocument(
  slug: String,
  title: String,
  description: String,
  date: Date,
  image: String,
  content: any HTML
) -> Document {
  return Document(
    path: "articles/\(slug)",
    metadata: .init(
      site: author,
      title: title,
      description: description,
      date: date,
      image: image,
      author: author,
      type: .article
    ),
    content: {
      Layout(
        heading: title,
        description: description,
        date: date,
        image: image,
        children: { content }
      )
    }
  )
}

struct ArticleSection: HTML {
  let title: String
  let children: [any HTML]

  init(
    title: String,
    @HTMLBuilder children: @escaping () -> [any HTML]
  ) {
    self.title = title
    self.children = children()
  }

  func render() -> String {
    Section {
      Header {
        Heading(level: .two) { title }.styled(size: .xl3)
      }
      Main {
        children.map { $0.render() }.joined()
      }
    }
    .spaced()
    .render()
  }
}

struct ContentStack: HTML {
  let title: String
  let children: [any HTML]

  init(
    title: String,
    @HTMLBuilder children: @escaping () -> [any HTML]
  ) {
    self.title = title
    self.children = children()
  }

  func render() -> String {
    Stack {
      Heading(level: .three) { title }.styled(size: .lg)
      children.map { $0.render() }.joined()
    }
    .spaced()
    .render()
  }
}

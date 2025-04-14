import Foundation
import WebUI

/// A structure representing article data with relevant metadata and content.
struct ArticleData {
  let slug: String
  let title: String
  let description: String
  let date: Date
  let content: any HTML

  /// Initializes an ArticleData instance with the provided article details.
  /// - Parameters:
  ///   - slug: A unique identifier for the article.
  ///   - title: The title of the article.
  ///   - description: A brief description of the article.
  ///   - date: The publication date as an ISO8601 string.
  ///   - content: The HTML content of the article.
  init(slug: String, title: String, description: String, date: String, content: any HTML) {
    self.slug = slug
    self.title = title
    self.description = description
    let formatter = ISO8601DateFormatter()
    self.date = formatter.date(from: date) ?? Date()
    self.content = content
  }
}

/// Creates a document for an article with the specified metadata and content.
/// - Parameters:
///   - slug: A unique identifier for the article.
///   - title: The title of the article.
///   - description: A brief description of the article.
///   - date: The publication date of the article.
///   - image: The URL or path to the article's image.
///   - content: The HTML content of the article.
/// - Returns: A `Document` configured with the article's layout and metadata.
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
        date: date,
        image: image,
        children: { content }
      )
    }
  )
}

/// A structure representing an HTML section for an article with a title and content.
struct ArticleSection: HTML {
  let title: String
  let children: [any HTML]

  /// Initializes an ArticleSection with a title and HTML content.
  /// - Parameters:
  ///   - title: The title of the section.
  ///   - children: A closure that returns an array of HTML elements for the section.
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

/// A structure representing a stack of HTML content with a title.
struct ContentStack: HTML {
  let title: String
  let children: [any HTML]

  /// Initializes a ContentStack with a title and HTML content.
  /// - Parameters:
  ///   - title: The title of the content stack.
  ///   - children: A closure that returns an array of HTML elements for the stack.
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

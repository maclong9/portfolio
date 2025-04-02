import Foundation
import WebUI

@main
public struct Portfolio {
  // Create static routes
  public static let staticRoutes: [Document] = [
    ("index", "Home", "a Software Engineer, crafting intuitive solutions using modern technologies.", Home()),
    ("projects", "Projects", "A collection of open source projects I have worked on in the past.", Projects()),
    ("articles", "Blog", "Thoughts and musings on software development.", Articles()),
  ].map { (path: String, title: String, description: String, content: HTML) in
    Document(
      path: "\(path)",
      metadata: .init(title: title, description: description),
      content: { content }
    )
  }

  // Create article routes
  public static let articleRoutes: [Document] = Articles().articles.map { article in
    let (date, title, description, image, content) = (
      article.date, article.title, article.description, article.image, article.content
    )
    return Document(
      path: "articles/\(title.slugified())",
      metadata: .init(title: title, description: description, image: image),
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

  static func main() async throws {
    // Build static site
    try Application(routes: staticRoutes + articleRoutes).build()
  }
}

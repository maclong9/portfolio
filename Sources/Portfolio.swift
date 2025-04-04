import Foundation
import WebUI

let author = "Mac Long"

@main
public struct Portfolio {
  // Create static routes
  public static let staticRoutes: [Document] = [
    ("index", "Home", "a Software Engineer, crafting intuitive solutions using modern technologies.", Home())
  ].map { (path: String, title: String, description: String, content: HTML) in
    Document(
      path: "\(path)",
      metadata: .init(site: author, title: title, description: description, author: author, type: .website),
      content: { content }
    )
  }

  // Define all articles in one place
  private static let articles: [ArticleMetadata] = [
    ArticleMetadata(
      slug: "personal-setup",
      title: "Personal Setup",
      description:
        "Over the years, I’ve refined my workflow to maximize efficiency and satisfaction in my professional endeavors. In this article I go over some of the choices.",
      date: "2025-04-04T12:00:00Z",
      content: PersonalSetup()
    )
  ]

  // Create article routes from the articles array
  public static let articleRoutes: [Document] = articles.map { article in
    return Document(
      path: "articles/\(article.slug)",
      metadata: .init(
        site: author,
        title: article.title,
        description: article.description,
        date: article.date,
        image: "/articles/\(article.slug)/cover.jpg",
        author: author,
        type: .article
      ),
      content: {
        Layout(
          heading: article.title,
          description: article.description,
          date: article.date,
          image: "/articles/\(article.slug)/cover.jpg",
          children: { article.content }
        )
      }
    )
  }

  static func main() async throws {
    try Application(routes: staticRoutes + articleRoutes).build()
  }
}

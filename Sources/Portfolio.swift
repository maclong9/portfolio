import Foundation
import WebUI

// TODO: Create content for pages
// TODO: Create 2–5 blog posts
// TODO: Figure out the best way to map articles across multiple pages, below is fine but the links don't need to be `Document`.

@main
struct Portfolio {
  static func main() async throws {
    // Create static routes with path, title, description and content
    let staticRoutes: [Document] = [
      ("index", "Home", "a Software Engineer, crafting intuitive solutions using modern technologies.", Home()),
      ("projects", "Projects", "A collection of open source projects I have worked on in the past.", Projects()),
      ("articles", "Blog", "Thoughts and musings on software development.", Articles()),
      ("uses", "Uses", "A collection of tools and technologies I use in my work.", Uses()),
    ].map { (path: String, title: String, description: String, content: HTML) in
      Document(
        path: "/portfolio/\(path)",
        metadata: .init(title: title, description: description),
        content: { content }
      )
    }

    // Create article routes with date, title, description, image and content
    let articleRoutes: [Document] = articles.map { article in
      let (date, title, description, image, content) = (
        article.date, article.title, article.description, article.image, article.content
      )
      return Document(
        path: "/portfolio/articles/\(title.slugified())",
        metadata: .init(title: title, description: description, image: image),
        content: {
          ArticleLayout(
            date: date, title: title, description: description, image: image,
            children: { content }
          )
        }
      )
    }

    // Build static site
    try Application(routes: staticRoutes + articleRoutes).build()
  }
}

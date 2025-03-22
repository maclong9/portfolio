import Foundation
import WebUI

@main
struct Portfolio {
  static func main() async throws {
    // Create static routes with path, title, description and content
    let staticRoutes: [Document] = [
      ("index", "Home", "a Software Engineer, crafting intuitive solutions using modern technologies.", Home()),
      ("projects", "Projects", "A collection of open source projects I have worked on in the past.", Projects()),
      ("blog", "Blog", "Thoughts and musings on software development.", Articles()),
      ("uses", "Uses", "A collection of tools and technologies I use in my work.", Uses()),
    ].map { (path: String, title: String, description: String, content: HTML) in
      Document(
        path: path,
        metadata: .init(title: title, description: description),
        content: { content }
      )
    }

    // Create article routes with date, title, description, image and content
    let articleRoutes: [Document] = [
      (Date(), "Hello, World!", "My first post.", "/articles/example.png", ExampleArticle()),
      (Date(), "Hello, Moon!", "My moon post.", "/articles/example.png", MoonArticle()),
    ].map { (date: Date, title: String, description: String, image: String, content: any HTML) in
      Document(
        path: "articles/\(title.slugified())",
        metadata: .init(title: title, description: description, image: image),
        content: {
          ArticleLayout(date: date, title: title, description: description, image: image, children: { content })
        }
      )
    }

    try Application(routes: staticRoutes + articleRoutes).build()
  }
}

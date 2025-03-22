import Foundation
import WebUI

@main
struct Portfolio {
  static func main() async throws {
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

    let articleRoutes = [
      (Date(), "Hello, World!", "My first post.", "/articles/example.png", ExampleArticle())
    ].map { date, title, description, image, content in
      Document(
        path: "articles/\(title.slugified())",
        metadata: .init(title: title, description: description),
        content: { content }
      )
    }

    try Application(routes: staticRoutes + articleRoutes).build()
  }
}

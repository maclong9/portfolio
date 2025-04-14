import Foundation
import WebUI

let author = "Mac Long"

@main
public struct Portfolio {
  public static let staticRoutes: [Document] = [
    ("index", "Home", "Software Engineer, crafting intuitive solutions.", Home())
  ].map { (path: String, title: String, description: String, content: HTML) in
    Document(
      path: "\(path)",
      metadata: .init(site: author, title: title, description: description, author: author, type: .website),
      content: { content }
    )
  }

  public static let articleRoutes: [Document] = []

  static func main() async throws {
    try Application(routes: staticRoutes + articleRoutes).build()
  }
}

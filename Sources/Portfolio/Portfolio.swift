import Foundation
import WebUI

#if os(Linux)
import FoundationNetworking
#endif

@main
public struct Portfolio: Sendable {
  public static let author = "Mac Long"

  // Articles are fetched first so they can be used in Home view
  let articles: [ArticleResponse]
  let articleDocuments: [Document]

  // Static routes will now be a computed property that uses the articles
  var staticRoutes: [Document] {
    [
      Document(
        path: "index",
        metadata: .init(
          site: Self.author,
          title: "Home",
          description: "Software Engineer, crafting intuitive solutions.",
          author: Self.author,
          type: .website
        ),
        head: "<link rel=\"icon\" href=\"public/icon.svg\" type=\"image/svg+xml\" />",
        content: { Home(articles: self.articles) }
      )
    ]
  }

  // Initialize with articles fetched from the service
  init() async throws {
    // First fetch the article data
    self.articles = try await ArticleService.fetchAllArticles()
    // Then create documents from them
    self.articleDocuments = articles.map { $0.document }
  }

  static func main() async throws {
    let portfolioInstance = try await Portfolio()
    // Combine both static routes and article documents
    let allRoutes = portfolioInstance.staticRoutes + portfolioInstance.articleDocuments
    try Application(routes: allRoutes).build(publicDirectory: "Sources/Portfolio/Public")
  }
}

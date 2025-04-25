import Foundation
import Logging
import WebUI

@main
public struct Portfolio {
  public static let author = "Mac Long"
  private static let logger = Logger(label: "Portfolio")

  let articles: [ArticleResponse]
  let articleDocuments: [Document]
  var routes: [Document] {
    [
      Home(articles: articles).document,
      Projects().document,
    ]
  }

  init(articles: [ArticleResponse]) {
    self.articles = articles
    self.articleDocuments = articles.map { $0.document }
  }

  static func main() async throws {
    let logLevelString = ProcessInfo.processInfo.environment["LOG_LEVEL"] ?? "info"
    LoggingSetup.bootstrap(logLevelString: logLevelString)

    let articles: [ArticleResponse]
    do {
      articles = try ArticleService.fetchAllArticles()
      logger.info("Successfully loaded \(articles.count) articles from local markdown files")
    } catch {
      logger.error("Error loading articles: \(error)")
      articles = []
    }

    let portfolioInstance = Portfolio(articles: articles)
    let allRoutes = portfolioInstance.routes + portfolioInstance.articleDocuments
    try Application(routes: allRoutes).build(assetsPath: "Sources/Portfolio/Public")
  }
}

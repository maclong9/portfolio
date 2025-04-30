import Foundation
import Logging
import WebUI

@main
public struct Portfolio {
  private static let logger = Logger(label: "com.maclong.portfolio")
  public static let author = "Mac Long"

  var articles: [ArticleResponse] = []
  var routes: [Document] {
    [
      Home(articles: articles).document,
      Projects().document,
    ] + articles.map(\.document)
  }

  static func main() async throws {
    LoggingSetup.bootstrap(
      logLevelString: ProcessInfo.processInfo.environment["LOG_LEVEL"] ?? "info")

    var portfolio = Portfolio()

    do {
      portfolio.articles = try ArticleService.fetchAllArticles()
      logger.info(
        "Successfully loaded \(portfolio.articles.count) articles from local markdown files")
    } catch {
      logger.error("Error loading articles: \(error)")
    }

    try Application(routes: portfolio.routes).build(assetsPath: "Sources/Portfolio/Public")
  }
}

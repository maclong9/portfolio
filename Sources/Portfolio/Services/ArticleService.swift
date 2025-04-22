import Foundation
import WebUI

struct ArticleResponse: Identifiable {
  let id: String
  let title: String
  let description: String
  let htmlContent: String
  let publishedDate: Date?

  var document: Document {
    Document(
      path: "articles/\(id)",
      metadata: .init(
        site: Portfolio.author,
        title: title,
        description: description,
        author: Portfolio.author,
        type: .article
      ),
      head: """
          <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
          <script>hljs.highlightAll();</script>
        """,
      content: {
        Layout(date: publishedDate) {
          htmlContent
          Style { typographyStyles }
        }
      }
    )
  }

  init(from parsedArticle: MarkdownService.ParsedArticle) {
    self.id = parsedArticle.id.pathFormatted()
    self.title = parsedArticle.title
    self.description = parsedArticle.description
    self.htmlContent = parsedArticle.htmlContent
    self.publishedDate = parsedArticle.publishedDate
  }
}

enum ArticleService {
  /// Fetches all articles from the local Articles directory
  static func fetchAllArticles() throws -> [ArticleResponse] {
    let parsedArticles = try MarkdownService.getAllArticles()
    return parsedArticles.map { ArticleResponse(from: $0) }
  }
}

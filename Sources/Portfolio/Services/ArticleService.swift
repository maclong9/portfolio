import Foundation
import WebUI

enum ArticleService {
  static func fetchAllArticles() throws -> [ArticleResponse] {
    let fileManager = FileManager.default
    let articlesDirectoryURL = URL(fileURLWithPath: "Sources/Portfolio/Articles")
    let fileURLs = try fileManager.contentsOfDirectory(
      at: articlesDirectoryURL,
      includingPropertiesForKeys: nil,
      options: .skipsHiddenFiles
    ).filter { $0.pathExtension == "md" }

    return try fileURLs.map { url in
      let id = url.deletingPathExtension().lastPathComponent
      let content = try String(contentsOf: url, encoding: .utf8)
      let parsed = MarkdownParser.parseMarkdown(content)
      return ArticleResponse(id: id, parsed: parsed)
    }
  }
}

struct ArticleResponse {
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
        date: publishedDate,
        author: Portfolio.author,
        type: .article,
      ),
      head: """
          <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
          <script>hljs.highlightAll();</script>
        """,
      content: {
        Layout {
          htmlContent
          Style { typographyStyles }
        }
      }
    )
  }

  init(id: String, parsed: MarkdownParser.ParsedMarkdown) {
    self.id = id.pathFormatted()
    self.htmlContent = parsed.htmlContent
    self.title = parsed.frontMatter["title"] as? String ?? "Untitled"
    self.description = parsed.frontMatter["description"] as? String ?? ""
    self.publishedDate = parsed.frontMatter["published"] as? Date
  }
}

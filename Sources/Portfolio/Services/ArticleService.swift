import Foundation
import WebUI

enum ArticleService {
  static func fetchAllArticles() throws -> [ArticleResponse] {
    let fileURLs = try fetchMarkdownFiles()
    return try fileURLs.map(createArticleResponse)
  }

  private static func fetchMarkdownFiles() throws -> [URL] {
    try FileManager.default.contentsOfDirectory(
      at: URL(fileURLWithPath: "Sources/Portfolio/Articles"),
      includingPropertiesForKeys: nil,
      options: .skipsHiddenFiles
    ).filter { $0.pathExtension == "md" }
  }

  private static func createArticleResponse(from url: URL) throws -> ArticleResponse {
    ArticleResponse(
      id: url.deletingPathExtension().lastPathComponent,
      parsed: MarkdownParser.parseMarkdown(try String(contentsOf: url, encoding: .utf8))
    )
  }
}

struct ArticleResponse: CardItem {
  let id: String
  let title: String
  let description: String
  let htmlContent: String
  let publishedDate: Date?

  var url: String { "/articles/\(id)" }
  let technologies: [String]? = nil

  var document: Document {
    Document(
      path: "/articles/\(id)",
      metadata: .init(
        site: Portfolio.author,
        title: title,
        description: description,
        date: publishedDate,
        image: "/public/articles/\(id).jpg",
        author: Portfolio.author,
        type: .article,
        themeColor: .init(light: "oklch(92% 0.004 286.32)", dark: "oklch(14.1% 0.005 285.823)")
      ),
      scripts: [
        "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js",
        "https://cdnjs.cloudflare.com/ajax/libs/highlightjs-line-numbers.js/2.9.0/highlightjs-line-numbers.min.js",
      ],
      stylesheets: ["/public/articles/typography.css"],
      head: "<script defer src=\"/public/articles/syntax.js\"></script>",
      content: {
        Layout(
          title: title,
          description: description,
          published: publishedDate,
        ) {
          htmlContent
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

import Foundation
import WebUI

#if os(Linux)
import FoundationNetworking
#endif

struct ArticleResponse: Identifiable {
  let id: String
  let title: String
  let description: String
  let htmlContent: String

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
          <link rel=\"icon\" href=\"icon.svg\" type=\"image/svg+xml\" />
          <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
          <script>
            document.addEventListener('DOMContentLoaded', (event) => {
              document.querySelectorAll('section pre code:not(.language-swift').forEach((el) => {
                  hljs.highlightElement(el);
              });
            });
          </script>
        """,
      content: {
        Layout {
          Fragment { htmlContent }
          Style { typographyStyles }
        }
      }
    )
  }
}

enum ArticleService {
  private static let baseURL = "https://api.swiftinit.org/render/maclong9.portfolio:main/portfolio/"
  private static let authHeader = "Unidoc 4410635584_e9e9cd4e119016ea"

  static let availableSlugs = ["personal-setup", "introduction-to-webui"]

  /// Fetches all articles defined in availableSlugs
  static func fetchAllArticles() async throws -> [ArticleResponse] {
    var articles: [ArticleResponse] = []

    for slug in availableSlugs {
      if let article = try await fetchArticle(slug: slug) {
        articles.append(article)
      }
    }

    return articles
  }

  /// Fetches a single article by its slug
  static func fetchArticle(slug: String) async throws -> ArticleResponse? {
    guard let url = URL(string: baseURL + slug) else {
      print("Invalid URL for slug: \(slug)")
      return nil
    }

    var request = URLRequest(url: url)
    request.setValue(authHeader, forHTTPHeaderField: "Authorization")

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      print("Failed to fetch article for slug: \(slug), status: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
      return nil
    }

    guard let htmlString = String(data: data, encoding: .utf8) else {
      print("Failed to decode response for slug: \(slug)")
      return nil
    }

    // Extract metadata
    let title = extractTitle(from: htmlString) ?? slug.capitalized
    let description = extractDescription(from: htmlString) ?? "Article about \(slug)"

    return ArticleResponse(id: slug, title: title, description: description, htmlContent: htmlString)
  }

  // Helper to extract title from HTML (simplified regex for <h1>)
  private static func extractTitle(from html: String) -> String? {
    let pattern = "<h1[^>]*>(.*?)</h1>"
    guard let regex = try? NSRegularExpression(pattern: pattern),
      let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
      let range = Range(match.range(at: 1), in: html)
    else {
      return nil
    }
    return String(html[range])
  }

  // Helper to extract description from HTML (simplified regex for first <p>)
  private static func extractDescription(from html: String) -> String? {
    let pattern = "<p[^>]*>(.*?)</p>"
    guard let regex = try? NSRegularExpression(pattern: pattern),
      let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
      let range = Range(match.range(at: 1), in: html)
    else {
      return nil
    }
    return String(html[range])
  }
}

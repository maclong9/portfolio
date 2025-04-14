import Foundation
import WebUI

#if os(Linux)
import FoundationNetworking
#endif

let author = "Mac Long"

@main
public struct Portfolio: Sendable {
  public static let staticRoutes: [Document] = [
    ("index", "Home", "Software Engineer, crafting intuitive solutions.", Home())
  ].map { (path: String, title: String, description: String, content: HTML) in
    Document(
      path: "\(path)",
      metadata: .init(site: author, title: title, description: description, author: author, type: .website),
      content: { content }
    )
  }

  static let slugs = ["personal-setup", "my-article"]
  let articles: [Document]

  // Initialize articles by fetching content for each slug
  init() async throws {
    self.articles = try await Self.fetchArticles()
  }

  // Fetch articles for all slugs
  private static func fetchArticles() async throws -> [Document] {
    var documents: [Document] = []
    for slug in slugs {
      if let document = try await fetchArticle(for: slug) {
        documents.append(document)
      }
    }
    return documents
  }

  // Fetch a single article for a given slug
  private static func fetchArticle(for slug: String) async throws -> Document? {
    let urlString = "https://api.swiftinit.org/render/maclong9.portfolio/portfolio/\(slug)"
    guard let url = URL(string: urlString) else {
      print("Invalid URL for slug: \(slug)")
      return nil
    }

    var request = URLRequest(url: url)
    request.setValue("Unidoc 4410635584_e9e9cd4e119016ea", forHTTPHeaderField: "Authorization")

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      print("Failed to fetch article for slug: \(slug), status: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
      return nil
    }

    guard let htmlString = String(data: data, encoding: .utf8) else {
      print("Failed to decode response for slug: \(slug)")
      return nil
    }

    // Extract title, description, and cover image
    let title = extractTitle(from: htmlString) ?? slug.capitalized
    let description = extractDescription(from: htmlString) ?? "Article about \(slug)"
    let coverImage = extractCoverImage(from: htmlString)

    return Document(
      path: "articles/\(slug)",
      metadata: .init(
        site: author,
        title: title,
        description: description,
        author: author,
        type: .article
      ),
      content: {
        Layout(heading: title, description: description, image: coverImage) {
          "\(htmlString)"
          Style { typographyStyles }
        }
      }
    )
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

  // Helper to extract cover image from HTML (first <img> tag's src attribute)
  private static func extractCoverImage(from html: String) -> String? {
    let pattern = "<img[^>]+src=[\"'](.*?)['\"]"
    guard let regex = try? NSRegularExpression(pattern: pattern),
      let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
      let range = Range(match.range(at: 1), in: html)
    else {
      return nil
    }
    return String(html[range])
  }

  static func main() async throws {
    let portfolioInstance = try await Portfolio()
    let allRoutes = staticRoutes + portfolioInstance.articles
    try Application(routes: allRoutes).build()
  }
}

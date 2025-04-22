import Foundation
import Markdown

/// Service responsible for parsing Markdown files into HTML
struct MarkdownService {

  /// Represents the metadata extracted from a Markdown file
  struct ArticleMetadata {
    let title: String
    let description: String
    let publishedDate: Date?

    init(title: String, description: String, publishedDate: Date? = nil) {
      self.title = title
      self.description = description
      self.publishedDate = publishedDate
    }
  }

  /// Represents a parsed Markdown article
  struct ParsedArticle: Identifiable {
    let id: String
    let title: String
    let description: String
    let publishedDate: Date?
    let htmlContent: String

    init(id: String, metadata: ArticleMetadata, htmlContent: String) {
      self.id = id
      self.title = metadata.title
      self.description = metadata.description
      self.publishedDate = metadata.publishedDate
      self.htmlContent = htmlContent
    }
  }

  /// Get all markdown files from the Articles directory
  static func getAllArticles() throws -> [ParsedArticle] {
    let fileManager = FileManager.default
    let articlesDirectoryURL = getArticlesDirectoryURL()

    guard
      let fileURLs = try? fileManager.contentsOfDirectory(
        at: articlesDirectoryURL,
        includingPropertiesForKeys: nil,
        options: .skipsHiddenFiles
      ).filter({ $0.pathExtension == "md" })
    else {
      print("Failed to get markdown files from \(articlesDirectoryURL.path)")
      return []
    }

    return try fileURLs.compactMap { url in
      let id = url.deletingPathExtension().lastPathComponent
      return try parseMarkdownFile(at: url, id: id)
    }
  }

  /// Parse a single markdown file into HTML
  static func parseMarkdownFile(at url: URL, id: String) throws -> ParsedArticle {
    let fileContents = try String(contentsOf: url, encoding: .utf8)

    // Split the content to extract frontmatter/metadata
    let (metadata, markdownContent) = extractMetadata(from: fileContents)

    // Parse the markdown content to HTML
    let document = Document(parsing: markdownContent)
    var renderer = HtmlRenderer()
    let html = renderer.render(document)

    return ParsedArticle(id: id, metadata: metadata, htmlContent: html)
  }

  /// Extract metadata from the markdown content
  private static func extractMetadata(from content: String) -> (ArticleMetadata, String) {
    let lines = content.components(separatedBy: .newlines)
    var title = "Untitled Article"
    var description = ""
    var publishedDate: Date? = nil
    var contentStartIndex = 0

    // Find title (first h1)
    for (index, line) in lines.enumerated() {
      if line.hasPrefix("# ") {
        title = line.replacingOccurrences(of: "# ", with: "")
        contentStartIndex = index + 1
        break
      }
    }

    // Find published date if it exists (format: **Published:** April 15, 2025)
    for (index, line) in lines[contentStartIndex...].enumerated() {
      if line.contains("**Published:**") {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"

        if let dateString = line.components(separatedBy: "**Published:** ").last,
          let date = dateFormatter.date(from: dateString.trimmingCharacters(in: .whitespacesAndNewlines))
        {
          publishedDate = date
        }

        contentStartIndex = contentStartIndex + index + 1
        break
      }
    }

    // Find first paragraph for description
    for line in lines[contentStartIndex...] {
      let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
      if !trimmed.isEmpty && !trimmed.hasPrefix("#") {
        description = trimmed
        break
      }
    }

    // Return metadata and the content without any removed parts
    return (
      ArticleMetadata(title: title, description: description, publishedDate: publishedDate),
      content
    )
  }

  /// Get the URL for the Articles directory
  private static func getArticlesDirectoryURL() -> URL {
    // First try to locate it relative to the executable
    let executableURL = URL(fileURLWithPath: CommandLine.arguments[0])
    let executableDir = executableURL.deletingLastPathComponent()

    // Possible paths
    let possiblePaths = [
      executableDir.appendingPathComponent("Articles"),
      executableDir.appendingPathComponent("Sources/Portfolio/Articles"),
      URL(fileURLWithPath: "Sources/Portfolio/Articles"),
    ]

    for path in possiblePaths {
      if FileManager.default.fileExists(atPath: path.path) {
        return path
      }
    }

    // Default to current directory + Articles as fallback
    return URL(fileURLWithPath: "Articles", isDirectory: true)
  }
}

/// HTML Renderer for Markdown AST
private struct HtmlRenderer: MarkupWalker {
  private var html = ""

  mutating func render(_ document: Document) -> String {
    html = ""
    visit(document)
    return html
  }

  mutating func visitHeading(_ heading: Heading) {
    let level = heading.level
    html += "<h\(level)>"
    descendInto(heading)
    html += "</h\(level)>"
  }

  mutating func visitParagraph(_ paragraph: Paragraph) {
    html += "<p>"
    descendInto(paragraph)
    html += "</p>"
  }

  mutating func visitText(_ text: Text) {
    html += text.string
  }

  mutating func visitLink(_ link: Link) {
    html += "<a href=\"\(link.destination ?? "")\">"
    descendInto(link)
    html += "</a>"
  }

  mutating func visitEmphasis(_ emphasis: Emphasis) {
    html += "<em>"
    descendInto(emphasis)
    html += "</em>"
  }

  mutating func visitStrong(_ strong: Strong) {
    html += "<strong>"
    descendInto(strong)
    html += "</strong>"
  }

  mutating func visitCodeBlock(_ codeBlock: CodeBlock) {
    let language = codeBlock.language ?? ""
    html += "<pre><code class=\"language-\(language)\">"
    html += escapeHTML(codeBlock.code)
    html += "</code></pre>"
  }

  mutating func visitInlineCode(_ inlineCode: InlineCode) {
    html += "<code>"
    html += escapeHTML(inlineCode.code)
    html += "</code>"
  }

  mutating func visitListItem(_ listItem: ListItem) {
    html += "<li>"
    descendInto(listItem)
    html += "</li>"
  }

  mutating func visitUnorderedList(_ unorderedList: UnorderedList) {
    html += "<ul>"
    descendInto(unorderedList)
    html += "</ul>"
  }

  mutating func visitOrderedList(_ orderedList: OrderedList) {
    html += "<ol>"
    descendInto(orderedList)
    html += "</ol>"
  }

  mutating func visitBlockQuote(_ blockQuote: BlockQuote) {
    html += "<blockquote>"
    descendInto(blockQuote)
    html += "</blockquote>"
  }

  mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) {
    html += "<hr />"
  }

  mutating func visitImage(_ image: Image) {
    html += "<img src=\"\(image.source ?? "")\" alt=\"\(image.title ?? "")\" />"
  }

  mutating func visitTable(_ table: Table) {
    html += "<table>"
    descendInto(table)
    html += "</table>"
  }

  mutating func visitTableHead(_ tableHead: Table.Head) {
    html += "<thead>"
    insideTableHead = true
    descendInto(tableHead)
    insideTableHead = false
    html += "</thead>"
  }

  mutating func visitTableBody(_ tableBody: Table.Body) {
    html += "<tbody>"
    descendInto(tableBody)
    html += "</tbody>"
  }

  mutating func visitTableRow(_ tableRow: Table.Row) {
    html += "<tr>"
    descendInto(tableRow)
    html += "</tr>"
  }

  private var insideTableHead = false

  mutating func visitTableCell(_ tableCell: Table.Cell) {
    let tag = insideTableHead ? "th" : "td"
    html += "<\(tag)>"
    descendInto(tableCell)
    html += "</\(tag)>"
  }

  mutating func defaultVisit(_ markup: Markup) {
    descendInto(markup)
  }

  private func escapeHTML(_ string: String) -> String {
    string
      .replacingOccurrences(of: "&", with: "&amp;")
      .replacingOccurrences(of: "<", with: "&lt;")
      .replacingOccurrences(of: ">", with: "&gt;")
      .replacingOccurrences(of: "\"", with: "&quot;")
      .replacingOccurrences(of: "'", with: "&#39;")
  }

}

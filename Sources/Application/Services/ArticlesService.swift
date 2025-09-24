import Foundation
import WebUI
import WebUIMarkdown

/// Security-related errors for article processing
enum ArticleSecurityError: Error, LocalizedError {
    case untrustedSource(String)
    
    var errorDescription: String? {
        switch self {
        case .untrustedSource(let path):
            return "Attempted to process article from untrusted source: \(path)"
        }
    }
}

public enum ArticlesService {
    public static func fetchAllArticles(
        from directoryPath: String = "Articles"
    ) throws -> [ArticleResponse] {
        let fileURLs = try fetchMarkdownFiles(from: directoryPath)
        return fileURLs.compactMap { url in
            do {
                return try createArticleResponse(from: url)
            } catch {
                print("⚠️  Warning: Failed to process article '\(url.lastPathComponent)': \(error.localizedDescription)")
                return nil // Skip this article, continue with others
            }
        }
    }

    private static func fetchMarkdownFiles(from directoryPath: String) throws -> [URL] {
        try FileManager.default.contentsOfDirectory(
            at: URL(fileURLWithPath: directoryPath),
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        ).filter { $0.pathExtension == "md" }
    }

    private static func createArticleResponse(from url: URL) throws -> ArticleResponse {
        let content = try String(contentsOf: url, encoding: .utf8)
        
        // Validate that this is from a trusted source (our Articles directory)
        // This prevents path traversal and ensures we only process trusted content
        let trustedBasePath = URL(fileURLWithPath: "Articles").standardized
        guard url.standardized.path.hasPrefix(trustedBasePath.path) else {
            throw ArticleSecurityError.untrustedSource(url.path)
        }
        
        // Parse the trusted markdown content
        let parsed = try WebUIMarkdown().parseMarkdown(content)
        
        return ArticleResponse(
            id: url.deletingPathExtension().lastPathComponent,
            parsed: parsed
        )
    }
}

public struct ArticleResponse: Identifiable {
    public let id: String
    public let title: String
    public let description: String
    public let htmlContent: String
    public let publishedDate: Date?
    public let readTime: String?
    public let slug: String
    
    public init(id: String, parsed: WebUIMarkdown.ParsedMarkdown) {
        self.id = id
        self.slug = id.lowercased().replacingOccurrences(of: " ", with: "-")
        self.title = parsed.frontMatter["title"] as? String ?? "Untitled"
        self.description = parsed.frontMatter["description"] as? String ?? ""
        self.htmlContent = parsed.htmlContent
        
        // Try to get the published date - it might already be a Date or a String
        if let publishedDate = parsed.frontMatter["published"] as? Date {
            self.publishedDate = publishedDate
        } else if let dateString = parsed.frontMatter["published"] as? String {
            self.publishedDate = Self.parseDate(from: dateString)
        } else {
            self.publishedDate = nil
        }
        self.readTime = Self.calculateReadTime(from: parsed.htmlContent)
    }
    
    private static func parseDate(from dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.date(from: dateString)
    }
    
    private static func calculateReadTime(from htmlContent: String) -> String {
        // Strip HTML tags to get plain text
        let plainText = htmlContent.replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression)
        let wordCount = plainText.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.count
        let readTimeMinutes = max(1, wordCount / 200) // Average reading speed: 200 words per minute
        return "\(readTimeMinutes) min read"
    }
    
    // Convert to Card component
    public func toCard() -> Card {
        Card(
            title: title,
            description: description,
            tags: readTime.map { [$0] } ?? [],
            linkURL: "/posts/\(slug)",
            linkText: "Read more",
            newTab: false,
            publishedDate: publishedDate
        )
    }
}

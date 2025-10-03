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
        let directoryURL = URL(fileURLWithPath: directoryPath)

        // If directory doesn't exist, return empty array instead of throwing
        guard FileManager.default.fileExists(atPath: directoryURL.path) else {
            return []
        }

        return try FileManager.default.contentsOfDirectory(
            at: directoryURL,
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
    public let keywords: [String]

    public init(id: String, parsed: WebUIMarkdown.ParsedMarkdown) {
        self.id = id
        self.slug = id.lowercased().replacingOccurrences(of: " ", with: "-")

        // Extract metadata from content using the pattern:
        // 1. First bold line = title
        // 2. Hashtags = keywords
        // 3. Published date
        // 4. Summary (bold paragraph after published)
        let metadata = Self.extractMetadata(from: parsed.htmlContent)

        self.title = metadata.title ?? parsed.frontMatter["title"] as? String ?? "Untitled"
        self.description = metadata.summary ?? parsed.frontMatter["description"] as? String ?? ""
        self.keywords = metadata.keywords
        self.htmlContent = metadata.cleanedContent

        // Try to get the published date from extracted metadata or frontmatter
        if let extractedDate = metadata.publishedDate {
            self.publishedDate = extractedDate
        } else if let publishedDate = parsed.frontMatter["published"] as? Date {
            self.publishedDate = publishedDate
        } else if let dateString = parsed.frontMatter["published"] as? String {
            self.publishedDate = Self.parseDate(from: dateString)
        } else {
            self.publishedDate = nil
        }

        self.readTime = Self.calculateReadTime(from: metadata.cleanedContent)
    }
    
    private static func extractMetadata(from htmlContent: String) -> (title: String?, keywords: [String], publishedDate: Date?, summary: String?, cleanedContent: String) {
        var title: String?
        var keywords: [String] = []
        var publishedDate: Date?
        var summary: String?
        var cleanedContent = htmlContent
        var contentToRemove: [Range<String.Index>] = []

        // Pattern: Match both <p><strong>Title</strong></p> AND <p>**Title **</p>
        // Some markdown parsers convert ** to <strong>, others leave literal **
        let strongPattern = #"<p><strong>(.*?)</strong>\s*</p>"#
        let literalPattern = #"<p>\*{2,}(.+?)\*{2,}\s*</p>"#

        if let titleMatch = cleanedContent.range(of: strongPattern, options: .regularExpression) {
            // Case 1: Markdown converted to <strong> tags
            let titleHTML = String(cleanedContent[titleMatch])
            title = titleHTML
                .replacingOccurrences(of: #"<[^>]+>"#, with: "", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            contentToRemove.append(titleMatch)
        } else if let titleMatch = cleanedContent.range(of: literalPattern, options: .regularExpression) {
            // Case 2: Markdown left as literal ** asterisks
            let titleHTML = String(cleanedContent[titleMatch])
            title = titleHTML
                .replacingOccurrences(of: #"<[^>]+>"#, with: "", options: .regularExpression)
                .replacingOccurrences(of: #"\*+"#, with: "", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            contentToRemove.append(titleMatch)
        }

        // Pattern: #Keyword #AnotherKeyword
        let hashtagPattern = #"<p>#(\w+)(?:\s+#(\w+))*\s*</p>"#
        if let hashtagMatch = cleanedContent.range(of: hashtagPattern, options: .regularExpression) {
            let hashtagHTML = String(cleanedContent[hashtagMatch])
            let matches = hashtagHTML.matches(of: /#(\w+)/)
            keywords = matches.map { String($0.output.1) }
            contentToRemove.append(hashtagMatch)
        }

        // Pattern: Match both <p><strong>Published...</strong></p> AND <p>**Published...**</p>
        let publishedStrongPattern = #"<p><strong>Published:\s*(.*?)</strong>\**\s*</p>"#
        let publishedLiteralPattern = #"<p>\*{2,}Published:\s*(.+?)\*{2,}\s*</p>"#

        var publishedMatch: Range<String.Index>?
        if let match = cleanedContent.range(of: publishedStrongPattern, options: .regularExpression) {
            publishedMatch = match
            let publishedHTML = String(cleanedContent[match])
            if let dateMatch = publishedHTML.range(of: #"Published:\s*([^<*]+)"#, options: .regularExpression) {
                let dateText = String(publishedHTML[dateMatch])
                    .replacingOccurrences(of: "Published:", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                publishedDate = parseDate(from: dateText)
            }
            contentToRemove.append(match)
        } else if let match = cleanedContent.range(of: publishedLiteralPattern, options: .regularExpression) {
            publishedMatch = match
            let publishedHTML = String(cleanedContent[match])
            if let dateMatch = publishedHTML.range(of: #"Published:\s*([^*<]+)"#, options: .regularExpression) {
                let dateText = String(publishedHTML[dateMatch])
                    .replacingOccurrences(of: "Published:", with: "")
                    .replacingOccurrences(of: #"\*+"#, with: "", options: .regularExpression)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                publishedDate = parseDate(from: dateText)
            }
            contentToRemove.append(match)
        }

        // Extract summary if we found a published date
        if let publishedMatch = publishedMatch {
            // Extract summary: IMMEDIATELY after published date
            let afterPublished = publishedMatch.upperBound
            let remainingContent = cleanedContent[afterPublished...]

            // Match both <strong> and literal ** patterns
            let summaryStrongPattern = #"^\s*<p><strong>(.*?)</strong>\**\s*</p>"#
            let summaryLiteralPattern = #"^\s*<p>\*{2,}(.+?)\*{2,}\s*</p>"#

            if let summaryMatch = remainingContent.range(of: summaryStrongPattern, options: .regularExpression) {
                let summaryHTML = String(remainingContent[summaryMatch])
                summary = summaryHTML
                    .replacingOccurrences(of: #"<[^>]+>"#, with: "", options: .regularExpression)
                    .replacingOccurrences(of: #"\*+"#, with: "", options: .regularExpression)
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                // Convert relative range to absolute range for removal
                let relativeStart = remainingContent.distance(from: remainingContent.startIndex, to: summaryMatch.lowerBound)
                let relativeEnd = remainingContent.distance(from: remainingContent.startIndex, to: summaryMatch.upperBound)
                let baseOffset = cleanedContent.distance(from: cleanedContent.startIndex, to: afterPublished)
                let absoluteStart = baseOffset + relativeStart
                let absoluteEnd = baseOffset + relativeEnd
                let absoluteRange = cleanedContent.index(cleanedContent.startIndex, offsetBy: absoluteStart)..<cleanedContent.index(cleanedContent.startIndex, offsetBy: absoluteEnd)
                contentToRemove.append(absoluteRange)
            } else if let summaryMatch = remainingContent.range(of: summaryLiteralPattern, options: .regularExpression) {
                let summaryHTML = String(remainingContent[summaryMatch])
                summary = summaryHTML
                    .replacingOccurrences(of: #"<[^>]+>"#, with: "", options: .regularExpression)
                    .replacingOccurrences(of: #"\*+"#, with: "", options: .regularExpression)
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                // Convert relative range to absolute range for removal
                let relativeStart = remainingContent.distance(from: remainingContent.startIndex, to: summaryMatch.lowerBound)
                let relativeEnd = remainingContent.distance(from: remainingContent.startIndex, to: summaryMatch.upperBound)
                let baseOffset = cleanedContent.distance(from: cleanedContent.startIndex, to: afterPublished)
                let absoluteStart = baseOffset + relativeStart
                let absoluteEnd = baseOffset + relativeEnd
                let absoluteRange = cleanedContent.index(cleanedContent.startIndex, offsetBy: absoluteStart)..<cleanedContent.index(cleanedContent.startIndex, offsetBy: absoluteEnd)
                contentToRemove.append(absoluteRange)
            }
        }

        // Remove all matched content in reverse order to maintain indices
        for range in contentToRemove.sorted(by: { $0.lowerBound > $1.lowerBound }) {
            cleanedContent.removeSubrange(range)
        }

        // Clean up extra whitespace and empty paragraphs
        cleanedContent = cleanedContent
            .replacingOccurrences(of: #"<p>\s*</p>"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"\n\s*\n\s*\n+"#, with: "\n\n", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return (title, keywords, publishedDate, summary, cleanedContent)
    }

    private static func parseDate(from dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }

        // Try multiple date formats
        let formats = [
            "d MMMM yyyy",        // 24 September 2025
            "MMMM d, yyyy",       // September 24, 2025
            "d'st' MMMM yyyy",    // 24th September 2025
            "d'nd' MMMM yyyy",    // 22nd September 2025
            "d'rd' MMMM yyyy",    // 23rd September 2025
            "d'th' MMMM yyyy"     // 24th September 2025
        ]

        let formatter = DateFormatter()
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }

        return nil
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
        // Keywords only - read time will be passed separately
        let tags = keywords.map { "#\($0)" }

        return Card(
            title: title,
            description: description,
            tags: tags,
            linkURL: "/posts/\(slug)",
            linkText: "Read more",
            newTab: false,
            publishedDate: publishedDate,
            readTime: readTime
        )
    }
}

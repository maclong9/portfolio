import Foundation
import WebUI
import WebUIMarkdown

public enum ArticleService {
    public static func fetchAllArticles(
        from directoryPath: String = "Articles",
        root: Bool = false
    ) throws -> [ArticleResponse] {
        let fileURLs = try fetchMarkdownFiles(from: directoryPath)
        return try fileURLs.map { url in
            try createArticleResponse(from: url, root: root)
        }
    }

    private static func fetchMarkdownFiles(from directoryPath: String) throws -> [URL] {
        try FileManager.default.contentsOfDirectory(
            at: URL(fileURLWithPath: directoryPath),
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        ).filter { $0.pathExtension == "md" }
    }

    private static func createArticleResponse(from url: URL, root: Bool) throws -> ArticleResponse {
        ArticleResponse(
            id: url.deletingPathExtension().lastPathComponent,
            parsed: try WebUIMarkdown().parseMarkdown(try String(contentsOf: url, encoding: .utf8)),
            root: root
        )
    }
}

public struct ArticleResponse: Document, CardItem {
    public let id: String
    public let title: String
    public let description: String
    public let htmlContent: String
    public let publishedDate: Date?
    public let root: Bool

    // MARK: - CardItem conformance
    public var url: String { root ? "\(id)" : "/articles/\(id)" }
    public var newTab: Bool = false
    public var action: CardAction = .readMore
    public let tags: [String]? = nil

    let personalData = PersonalData()

    // MARK: - Document conformance
    public var metadata: Metadata {
        Metadata(
            from: personalData.metadata,
            title: title,
            description: description,
            date: publishedDate,
            image: "/public/articles/\(id).jpg",
            type: .article,
            structuredData: StructuredData.article(
                headline: title,
                image: "/public/articles/\(id).jpg",
                author: personalData.metadata.author ?? "Mac Long",
                publisher: personalData.metadata.structuredData,
                datePublished: publishedDate ?? Date(),
                dateModified: publishedDate,
                description: description,
                url: "/articles/\(id)"
            )
        )
    }

    public var body: some HTML {
        Layout(
            title: title,
            description: description,
            published: publishedDate,
            isNotes: root
        ) {
            htmlContent
        }
    }

    public var path: String? {
        return root ? "\(id)" : "/articles/\(id)"
    }

    public var stylesheets: [String]? {
        ["https://static.maclong.uk/typography.v1.css"]
    }

    public init(id: String, parsed: WebUIMarkdown.ParsedMarkdown, root: Bool = false) {
        self.id = id.pathFormatted()
        self.htmlContent = parsed.htmlContent
        self.title = parsed.frontMatter["title"] as? String ?? "Untitled"
        self.description = parsed.frontMatter["description"] as? String ?? ""
        self.publishedDate = parsed.frontMatter["published"] as? Date
        self.root = root
    }
}

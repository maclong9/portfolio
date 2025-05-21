import Foundation
import WebUI
import WebUIMarkdown

enum ArticleService {
    static func fetchAllArticles() throws -> [ArticleResponse] {
        let fileURLs = try fetchMarkdownFiles()
        return try fileURLs.map(createArticleResponse)
    }

    private static func fetchMarkdownFiles() throws -> [URL] {
        try FileManager.default.contentsOfDirectory(
            at: URL(fileURLWithPath: "Sources/Articles"),
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        ).filter { $0.pathExtension == "md" }
    }

    private static func createArticleResponse(from url: URL) throws -> ArticleResponse {
        ArticleResponse(
            id: url.deletingPathExtension().lastPathComponent,
            parsed: WebUIMarkdown().parseMarkdown(try String(contentsOf: url, encoding: .utf8))
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
    var newTab: Bool = false
    var action: CardAction = .readMore

    let tags: [String]? = nil

    var document: Document {
        Document(
            path: "/articles/\(id)",
            metadata: .init(
                site: Application.metadata.author,
                title: title,
                description: description,
                date: publishedDate,
                image: "/public/articles/\(id).jpg",
                author: Application.metadata.author,
                type: .article,
                structuredData: StructuredData.article(
                    headline: title,
                    image: "/public/articles/\(id).jpg",
                    author: Application.metadata.author ?? "Mac",
                    publisher: Application.metadata.structuredData,
                    datePublished: publishedDate ?? Date(),
                    dateModified: publishedDate,
                    description: description,
                    url: "/articles/\(id)"
                )
            ),
            stylesheets: ["https://static.maclong.uk/typography.v1.css"],
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

    init(id: String, parsed: WebUIMarkdown.ParsedMarkdown) {
        self.id = id.pathFormatted()
        self.htmlContent = parsed.htmlContent
        self.title = parsed.frontMatter["title"] as? String ?? "Untitled"
        self.description = parsed.frontMatter["description"] as? String ?? ""
        self.publishedDate = parsed.frontMatter["published"] as? Date
    }
}

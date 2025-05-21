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
                    publisher: Application.metadata.site ?? "Portfolio",
                    datePublished: publishedDate ?? Date(),
                    dateModified: publishedDate,
                    description: description,
                    url: "/articles/\(id)"
                )
            ),
            scripts: [
                Script(src: "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"),
                Script(
                    src:
                        "https://cdnjs.cloudflare.com/ajax/libs/highlightjs-line-numbers.js/2.9.0/highlightjs-line-numbers.min.js"
                ),
            ],
            stylesheets: ["https://static.maclong.uk/typography.v1.css"],
            head: """
                <script>
                  hljs.highlightAll();
                  hljs.initLineNumbersOnLoad({
                      singleLine: true
                  });
                  document.addEventListener('DOMContentLoaded', () => {
                      document.querySelectorAll('pre code').forEach(block => {
                          const wrapper = document.createElement('div');
                          wrapper.className = 'code-block-wrapper';
                          block.parentNode.before(wrapper);
                          wrapper.appendChild(block.parentNode);

                          const lang = (block.className.match(/language-(\\w+)/)?.[1] || 'plaintext');
                          if (lang === 'plaintext' || lang === 'text') {
                              block.classList.add('nohljsln');
                          } else {
                              const langSpan = document.createElement('span');
                              langSpan.className = 'code-language';
                              langSpan.textContent = lang;
                              wrapper.prepend(langSpan);

                              const copyBtn = document.createElement('button');
                              copyBtn.className = 'copy-button';
                              copyBtn.textContent = 'Copy';
                              copyBtn.onclick = () => {
                                  navigator.clipboard.writeText(block.textContent).then(() => {
                                      copyBtn.textContent = 'Copied!';
                                      setTimeout(() => copyBtn.textContent = 'Copy', 2000);
                                  });
                              };
                              wrapper.appendChild(copyBtn);
                          }
                      });
                  });
                </script>
                """,
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

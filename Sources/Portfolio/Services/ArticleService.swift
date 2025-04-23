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
        image: "public/articles/\(id).jpg",
        author: Portfolio.author,
        type: .article
      ),
      scripts: ["https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"],
      head: """
          <script>
            hljs.highlightAll();
            document.addEventListener('DOMContentLoaded', () => {
              document.querySelectorAll('pre code').forEach(block => {
                const wrapper = document.createElement('div');
                wrapper.className = 'code-block-wrapper';
                block.parentNode.before(wrapper);
                wrapper.appendChild(block.parentNode);
                
                const lang = (block.className.match(/language-(\\w+)/)?.[1] || 'text');  
                if(lang !== 'text') {
                  const langFormatted = lang.charAt(0).toUpperCase() + lang.slice(1);
                  const langSpan = document.createElement('span');
                  langSpan.className = 'code-language';
                  langSpan.textContent = langFormatted;
                  wrapper.prepend(langSpan);
                }

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
              });
            });
          </script>
        """,
      content: {
        Layout {
          htmlContent
          typographyStyles
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

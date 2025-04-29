import Foundation
import WebUI

enum ArticleService {
  static func fetchAllArticles() throws -> [ArticleResponse] {
    let fileURLs = try FileManager.default.contentsOfDirectory(
      at: URL(fileURLWithPath: "Sources/Portfolio/Articles"),
      includingPropertiesForKeys: nil,
      options: .skipsHiddenFiles
    ).filter { $0.pathExtension == "md" }

    return try fileURLs.map { url in
      ArticleResponse(
        id: url.deletingPathExtension().lastPathComponent,
        parsed: MarkdownParser.parseMarkdown(try String(contentsOf: url, encoding: .utf8))
      )
    }
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
      path: "articles/\(id)",
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
      head: """
          <script>
            hljs.highlightAll();
            hljs.initLineNumbersOnLoad({
              singleLine: true,
              exclude: ['language-text', 'language-plaintext']
            });
            document.addEventListener('DOMContentLoaded', () => {
              document.querySelectorAll('pre code').forEach(block => {
                const wrapper = document.createElement('div');
                wrapper.className = 'code-block-wrapper';
                block.parentNode.before(wrapper);
                wrapper.appendChild(block.parentNode);
                
                const lang = (block.className.match(/language-(\\w+)/)?.[1] || 'plaintext');  
                const langSpan = document.createElement('span');
                langSpan.className = lang === 'plaintext' ? 'nohljsln' : 'code-language';
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

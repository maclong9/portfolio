**Beyond CLI Tools: Building Web Applications with Swift******

  


**While Swift excels at command line tools, it's also powerful for web development. This very website you're reading is built using Swift with the ****[WebUI framework**](https://github.com/maclong9/web-ui)**, demonstrating Swift's versatility beyond mobile apps.******

  


**Static Site Generation with Swift******

  


The portfolio site uses a custom Swift static site generator built on WebUI, which provides:

  


**Declarative Component Architecture******

struct Layout: Element {

    let title: String

    let content: () -> some Markup

    

    var body: some Markup {

        HTML {

            Head {

                Title(title)

                // Meta tags, stylesheets, etc.

            }

            Body {

                Header()

                Main { content() }  

                Footer()

            }

        }

    }

}

  


  


**Type-Safe HTML Generation******

struct ArticleCard: Element {

    let article: ArticleResponse

    

    var body: some Markup {

        Link(to: "/posts/\\(article.slug)") {

            Card {

                Stack(classes: ["flex", "flex-col"]) {

                    Heading(.subtitle, article.title)

                    Text(article.description)

                    Text("\\(article.readTime) • \\(article.publishedDate)")

                }

            }

        }

    }

}

  


  


**Markdown Processing with WebUIMarkdown******

public enum ArticlesService {

    public static func fetchAllArticles() throws -> [ArticleResponse] {

        let fileURLs = try fetchMarkdownFiles(from: "Articles")

        return try fileURLs.map { url in

            let content = try String(contentsOf: url, encoding: .utf8)

            let parsed = try WebUIMarkdown().parseMarkdown(content)

            return ArticleResponse(id: url.lastPathComponent, parsed: parsed)

        }

    }

}

  


  


**Build and Deployment Pipeline******

  


The Swift-based build system:

  


  1. **Compiles Swift code** into a static site generator executable
  2. **Processes Markdown articles** with frontmatter metadata extraction
  3. **Generates HTML files** with TailwindCSS styling and progressive enhancement
  4. **Deploys to Cloudflare Pages** with automatic builds on Git push

  


# Build the site generator

swift build -c release

  


# Generate the static site  

swift run

  


# Output ready for deployment in .output/dist/

  


**Performance Benefits******

  


Using Swift for static site generation provides:

  * **Compile-time safety**: Type checking prevents runtime errors
  * **Performance**: Native compilation yields fast build times
  * **Maintainability**: Familiar Swift syntax for iOS developers
  * **Integration**: Seamless use of Swift Package Manager dependencies

  


The combination of Swift's type safety, WebUI's declarative syntax, and native performance creates a pleasant development experience for content-focused websites.

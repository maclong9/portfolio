import WebUI

struct Home: HTML {
    let articles: [ArticleResponse]

    var document: Document {
        .init(
            path: "",
            metadata: Metadata(from: Application.metadata, title: "Home"),
            content: { self }
        )
    }

    init(articles: [ArticleResponse] = []) {
        self.articles = articles.sorted {
            guard let date1 = $0.publishedDate, let date2 = $1.publishedDate else { return false }
            return date1 > date2
        }
    }

    func render() -> String {
        Layout(
            title: "Software Engineer, Skater & Musician",
            description:
                "I'm Mac, a software engineer based out of the United Kingdom. I enjoy building robust and efficient software. Read some of my articles below."
        ) {
            Collection(items: articles)
        }.render()
    }
}

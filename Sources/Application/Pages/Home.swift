import Shared
import WebUI

struct Home: Document {
    let articles: [ArticleResponse]

    var path: String? { "index" }

    var metadata: Metadata {
        .init(from: Application().metadata, title: "Home")
    }

    var body: some HTML {
        Layout(
            title: "Software Engineer, Skater & Musician",
            description:
                "I'm Mac, a software engineer based out of the United Kingdom. I enjoy building forward thinking and efficient solutions. Read some of my articles below."
        ) {
            CardCollection(items: articles)
        }
    }

    init(articles: [ArticleResponse] = []) {
        self.articles = articles.sorted {
            guard let date1 = $0.publishedDate, let date2 = $1.publishedDate else { return false }
            return date1 > date2
        }
    }
}

import Foundation
import WebUI

/// A dynamic document that represents a single article loaded from markdown
struct DynamicArticle: Document {
    let article: ArticleResponse
    
    var path: String? { "posts/\(article.slug)" }
    
    var metadata: Metadata {
        Metadata(
            from: Application().metadata,
            title: "\(article.title) - Mac Long",
            description: article.description,
            date: article.publishedDate,
            keywords: ["article", "blog", "development"] + (Application().metadata.keywords ?? [])
        )
    }
    
    var body: some Markup {
        Layout(
            path: "posts/\(article.slug)",
            title: "\(article.title) - Mac Long",
            description: article.description,
            breadcrumbs: [
                Breadcrumb(title: "Mac Long", url: "/"),
                Breadcrumb(title: "Posts", url: "/posts"),
                Breadcrumb(title: article.title, url: "#"),
            ],
            emoji: article.emoji
        ) {
            ArticleLayout(article: article, contentHTML: article.htmlContent)
        }
    }
}


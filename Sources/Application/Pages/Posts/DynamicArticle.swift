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
            pageHeader: .post(
                title: article.title,
                description: article.description,
                date: article.publishedDate ?? Date(),
                keywords: article.keywords
            )
        ) {
            // Article content
            Article {
                Stack(classes: ["max-w-2xl", "mx-auto", "prose", "prose-lg"]) {
                    // Summary as first paragraph (bold)
                    if !article.description.isEmpty {
                        Text(article.description, classes: ["font-bold", "text-lg", "mb-4"])
                    }

                    article.htmlContent
                }

                // Back to posts link
                Stack(classes: ["max-w-2xl", "mx-auto", "mt-12", "pt-8", "border-t", "border-zinc-200", "dark:border-zinc-800"]) {
                    Link(
                        "← Back to Posts",
                        to: "/posts",
                        classes: [
                            "inline-flex", "items-center", "gap-2",
                            "text-teal-600", "dark:text-teal-400",
                            "hover:text-teal-700", "dark:hover:text-teal-300",
                            "transition-colors",
                        ]
                    )
                }
            }
        }
    }
}


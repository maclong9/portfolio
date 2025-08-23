import Foundation
import WebUI

struct HowISetUpANewMac: Document {
    var path: String? { "posts/how-i-set-up-a-new-mac" }

    var metadata: Metadata {
        Metadata(from: Application().metadata, title: "Setting Up a New Mac - Mac Long")
    }

    private var article: ArticleResponse? {
        do {
            let articles = try ArticlesService.fetchAllArticles()
            return articles.first { $0.slug == "how-i-set-up-a-new-mac" }
        } catch {
            print("Error loading article: \(error)")
            return nil
        }
    }

    var body: some Markup {
        guard let article = article else {
            return AnyMarkup(
                Layout(
                    path: "posts/how-i-set-up-a-new-mac",
                    title: "Article Not Found - Mac Long",
                    description: "The requested article could not be found.",
                    breadcrumbs: [
                        Breadcrumb(title: "Mac Long", url: "/"),
                        Breadcrumb(title: "Posts", url: "/posts"),
                        Breadcrumb(title: "Article Not Found", url: "#"),
                    ]
                ) {
                    Stack(classes: ["max-w-4xl", "mx-auto", "text-center", "py-12"]) {
                        Heading(.largeTitle, "Article Not Found", classes: ["text-2xl", "font-bold", "mb-4"])
                        Text("The requested article could not be found.", classes: ["text-lg", "mb-6"])
                        Link(to: "/posts", classes: ["text-teal-600", "hover:text-teal-700"]) {
                            Text("← Back to Posts")
                        }
                    }
                }
            )
        }

        return AnyMarkup(
            Layout(
                path: "posts/how-i-set-up-a-new-mac",
                title: "\(article.title) - Mac Long",
                description: article.description,
                breadcrumbs: [
                    Breadcrumb(title: "Mac Long", url: "/"),
                    Breadcrumb(title: "Posts", url: "/posts"),
                    Breadcrumb(title: article.title, url: "#"),
                ]
            ) {
                Article {
                    // Article header
                    Stack(classes: ["max-w-4xl", "mx-auto", "mb-8"]) {
                        Heading(.largeTitle, article.title, classes: ["text-3xl", "md:text-4xl", "font-bold", "mb-4"])
                        Text(article.description, classes: ["text-lg", "text-zinc-600", "dark:text-zinc-400", "mb-6"])
                        
                        // Article meta
                        Stack(classes: ["flex", "items-center", "space-x-4", "text-sm", "text-zinc-500", "dark:text-zinc-500"]) {
                            if let publishedDate = article.publishedDate {
                                Text(DateFormatter.articleDate.string(from: publishedDate))
                            }
                            if let readTime = article.readTime {
                                Text("• \(readTime)")
                            }
                        }
                    }
                    
                    // Article content
                    Stack(classes: ["max-w-4xl", "mx-auto", "prose", "dark:prose-invert", "prose-lg", "prose-zinc"]) {
                        article.htmlContent
                    }
                }
            }
        )
    }
}
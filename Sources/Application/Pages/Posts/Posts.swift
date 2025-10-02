import Foundation
import WebUI

struct Posts: Document {
  var path: String? { "posts" }

  var metadata: Metadata {
    Metadata(from: Application().metadata, title: "Posts")
  }

  // Load articles to display under posts
  private var articles: [ArticleResponse] {
    do {
      return try ArticlesService.fetchAllArticles().sorted { (lhs, rhs) in
        // Sort by date descending (newest first)
        guard let lhsDate = lhs.publishedDate,
              let rhsDate = rhs.publishedDate else {
          return false
        }
        return lhsDate > rhsDate
      }
    } catch {
      print("Error loading articles: \(error)")
      return []
    }
  }

  var body: some Markup {
    Layout(
      path: "posts",
      title: "Posts - Mac Long",
      description: "Thoughts on development, technology, and building for the web",
      breadcrumbs: [
        Breadcrumb(title: "Mac Long", url: "/"),
        Breadcrumb(title: "Posts", url: "/posts"),
      ]
    ) {
      if articles.isEmpty {
        Stack(classes: ["max-w-4xl", "mx-auto", "text-center", "py-12", "bg-white/50", "dark:bg-zinc-800/50", "backdrop-blur-xl", "border", "border-white/50", "dark:border-white/10", "rounded-2xl", "shadow-sm"]) {
          Icon(name: "file-text", classes: ["w-12", "h-12", "mx-auto", "mb-4", "opacity-50"])
          Heading(.headline, "No posts yet", classes: ["text-lg", "font-semibold", "mb-2"])
          Text("Check back soon for new content!", classes: ["opacity-75"])
        }
      } else {
        StandardPageLayout(
          title: "Posts",
          iconName: "file-text",
          count: articles.count,
          countLabel: "post",
          description: "Thoughts on development, technology, and building for the web."
        ) {
          CardCollection(
            cards: articles.map { $0.toCard() }
          )
        }
      }
    }
  }
}

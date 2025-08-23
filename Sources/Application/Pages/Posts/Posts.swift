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
      Stack(classes: ["max-w-4xl", "mx-auto"]) {
        // Page Header
        Stack(classes: ["text-center", "mb-12"]) {
          Heading(.largeTitle, "Posts", classes: ["text-3xl", "md:text-4xl", "font-bold", "mb-4"])
          Text(
            "Thoughts on development, technology, and building for the web.",
            classes: ["text-lg", "max-w-2xl", "mx-auto"]
          )
        }

        // Posts List
        if articles.isEmpty {
          Stack(classes: ["text-center", "py-12"]) {
            Icon(name: "file-text", classes: ["w-12", "h-12", "mx-auto", "mb-4", "opacity-50"])
            Heading(.headline, "No posts yet", classes: ["text-lg", "font-semibold", "mb-2"])
            Text("Check back soon for new content!", classes: ["opacity-75"])
          }
        } else {
          CardCollection(
            cards: articles.map { $0.toCard() }
          )
        }
      }
    }
  }
}

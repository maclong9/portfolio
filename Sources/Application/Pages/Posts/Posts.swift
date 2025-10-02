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
      ],
      showPageHeader: !articles.isEmpty,
      pageTitle: "Posts",
      iconName: "file-text",
      count: articles.count,
      countLabel: "post",
      pageDescription: "Thoughts on development, technology, and building for the web."
    ) {
      if articles.isEmpty {
        EmptyState(
          iconName: "file-text",
          title: "No posts yet",
          message: "Check back soon for new content!"
        )
      } else {
        MasonryCardLayout(
          cards: articles.map { $0.toCard() }
        )
      }
    }
  }
}

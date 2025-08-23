import Foundation
import WebUI

struct Posts: Document {
  var path: String? { "posts" }

  var metadata: Metadata {
    Metadata(from: Application().metadata, title: "Posts")
  }

  // MARK: - Mock Posts Data
  struct Post {
    let title: String
    let description: String
    let emoji: String
    let slug: String
    let date: Date
    let readTime: String
    let tags: [String]
  }

  let posts: [Post] = []

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

        // Posts List or Empty State
        if posts.isEmpty {
          Stack(classes: ["text-center", "py-12"]) {
            Icon(name: "edit-3", classes: ["w-12", "h-12", "mx-auto", "mb-4", "opacity-50"])
            Heading(.headline, "No posts yet", classes: ["text-lg", "font-semibold", "mb-2"])
            Text("Check back soon for new content!", classes: ["opacity-75"])
          }
        } else {
          CardCollection(
            cards: posts.map { post in
              Card(
                title: post.title,
                description: post.description,
                tags: Array(post.tags.prefix(3)),
                linkURL: "/posts/\(post.slug)",
                linkText: "Read more",
                emoji: post.emoji
              )
            }
          )
        }
      }
    }
  }
}

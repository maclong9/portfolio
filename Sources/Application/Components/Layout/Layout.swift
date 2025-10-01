import Foundation
import WebUI

public struct Layout: Element {
  public let path: String?
  let title: String
  let description: String
  let published: Date?
  let breadcrumbs: [Breadcrumb]?
  let emoji: String?
  let content: MarkupContentBuilder

  public init(
    path: String? = nil,
    title: String,
    description: String,
    published: Date? = nil,
    breadcrumbs: [Breadcrumb]? = nil,
    emoji: String? = nil,
    @MarkupBuilder content: @escaping MarkupContentBuilder
  ) {
    self.path = path
    self.title = title
    self.description = description
    self.published = published
    self.breadcrumbs = breadcrumbs
    self.emoji = emoji
    self.content = content
  }

  public var body: some Markup {
    BodyWrapper(classes: [
      "bg-zinc-50", "dark:bg-zinc-900", "text-zinc-900", "dark:text-zinc-100", "transition-colors",
      "duration-300",
    ]) {
      // Global Mobile Menu (outside header transform context)
      MobileMenu()

      Stack(classes: [
        "min-h-screen", "flex", "flex-col",
      ]) {
        LayoutHeader(breadcrumbs: breadcrumbs, emoji: emoji)

        Main(classes: ["flex-1", "px-4", "py-8", "pt-32"]) {
          Stack {
            MarkupString(content: content().map { $0.render() }.joined())
          }
        }

        Footer(classes: [
          "bg-white", "dark:bg-zinc-800", "border-t", "border-zinc-200", "dark:border-zinc-700",
          "px-4", "py-6", "space-y-2", "grid", "place-items-center",
        ]) {
          Stack(classes: ["flex", "items-center", "space-x-2"]) {
            // Posts link
            Link(
              to: "/posts",
              classes: [
                "p-2", "text-zinc-500", "hover:text-zinc-700",
                "dark:text-zinc-400", "dark:hover:text-zinc-200",
                "rounded-lg", "hover:bg-zinc-100", "dark:hover:bg-zinc-700",
                "transition-colors", "cursor-pointer",
              ]
            ) { Icon(name: "file-text") }

            // Email link
            Link(
              to: "mailto:hello@maclong.uk",
              classes: [
                "p-2", "text-zinc-500", "hover:text-zinc-700",
                "dark:text-zinc-400", "dark:hover:text-zinc-200",
                "rounded-lg", "hover:bg-zinc-100", "dark:hover:bg-zinc-700",
                "transition-colors", "cursor-pointer",
              ]
            ) { Icon(name: "mail") }

            // GitHub link
            Link(
              to: "https://github.com/maclong9",
              newTab: true,
              classes: [
                "p-2", "text-zinc-500", "hover:text-zinc-700",
                "dark:text-zinc-400", "dark:hover:text-zinc-200",
                "rounded-lg", "hover:bg-zinc-100", "dark:hover:bg-zinc-700",
                "transition-colors", "cursor-pointer",
              ]
            ) { Icon(name: "github") }
          }

          Stack(classes: ["text-zinc-500", "dark:text-zinc-400", "text-sm"]) {
            Text("© \(Date().formatAsYear()) ")
            Link(
              "Mac Long",
              to: "https://maclong.uk",
              classes: [
                "hover:text-teal-600", "dark:hover:text-teal-400", "transition-colors",
              ]
            )
            Text(".")
          }
        }
      }
    }
  }
}

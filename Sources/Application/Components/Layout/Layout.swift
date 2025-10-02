import Foundation
import WebUI

public struct Layout: Element {
  public let path: String?
  let title: String
  let description: String
  let published: Date?
  let breadcrumbs: [Breadcrumb]?
  let emoji: String?

  // Page header configuration
  let showPageHeader: Bool
  let pageTitle: String?
  let iconName: String?
  let count: Int?
  let countLabel: String?
  let pageDescription: String?

  let content: MarkupContentBuilder

  public init(
    path: String? = nil,
    title: String,
    description: String,
    published: Date? = nil,
    breadcrumbs: [Breadcrumb]? = nil,
    emoji: String? = nil,
    showPageHeader: Bool = false,
    pageTitle: String? = nil,
    iconName: String? = nil,
    count: Int? = nil,
    countLabel: String? = nil,
    pageDescription: String? = nil,
    @MarkupBuilder content: @escaping MarkupContentBuilder
  ) {
    self.path = path
    self.title = title
    self.description = description
    self.published = published
    self.breadcrumbs = breadcrumbs
    self.emoji = emoji
    self.showPageHeader = showPageHeader
    self.pageTitle = pageTitle
    self.iconName = iconName
    self.count = count
    self.countLabel = countLabel
    self.pageDescription = pageDescription
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
          Stack(classes: ["max-w-4xl", "mx-auto"]) {
            if showPageHeader {
              // Page Header with inline metadata
              Stack(classes: ["mb-8"]) {
                if let pageTitle = pageTitle {
                  Heading(.largeTitle, pageTitle, classes: ["text-3xl", "md:text-4xl", "font-bold", "mb-4"])
                }

                if let iconName = iconName, let count = count, let countLabel = countLabel, let pageDescription = pageDescription {
                  Stack(classes: ["flex", "items-center", "justify-between", "flex-wrap", "gap-4"]) {
                    // Left side: Count with icon
                    Stack(classes: ["flex", "items-center", "gap-2", "text-sm"]) {
                      Icon(name: iconName, classes: ["w-4", "h-4"])
                      Text("\(count) \(countLabel)\(count == 1 ? "" : "s")")
                    }

                    // Right side: Description text
                    Text(
                      pageDescription,
                      classes: ["text-sm", "text-zinc-600", "dark:text-zinc-400"]
                    )
                  }
                }
              }

              // Main content container (invisible wrapper)
              for item in content() {
                item
              }
            } else {
              // No header - just render content (for home page)
              for item in content() {
                item
              }
            }
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

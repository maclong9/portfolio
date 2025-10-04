import Foundation
import WebUI

public enum PageHeaderType {
  case collection(name: String, description: String)
  case post(title: String, description: String, date: Date, keywords: [String])
  case photos(albumName: String, filterButtons: MarkupContentBuilder?)
  case tool(name: String, emoji: String?, controls: MarkupContentBuilder?)
}

public struct Layout: Element {
  public let path: String?
  let title: String
  let description: String
  let published: Date?
  let breadcrumbs: [Breadcrumb]?
  let emoji: String?

  // Page header configuration
  let pageHeader: PageHeaderType?

  let content: MarkupContentBuilder

  public init(
    path: String? = nil,
    title: String,
    description: String,
    published: Date? = nil,
    breadcrumbs: [Breadcrumb]? = nil,
    emoji: String? = nil,
    pageHeader: PageHeaderType? = nil,
    @MarkupBuilder content: @escaping MarkupContentBuilder
  ) {
    self.path = path
    self.title = title
    self.description = description
    self.published = published
    self.breadcrumbs = breadcrumbs
    self.emoji = emoji
    self.pageHeader = pageHeader
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
            if let pageHeader = pageHeader {
              // Render page header based on type
              Stack(classes: [
                "flex", "items-center", "justify-between", "mb-6", "pb-4",
                "border-b", "border-zinc-200", "dark:border-zinc-700"
              ]) {
                switch pageHeader {
                case .collection(let name, let description):
                  // Left: Collection Name
                  Heading(.largeTitle, name, classes: ["text-2xl", "font-bold", "text-zinc-900", "dark:text-zinc-100"])
                  // Right: Collection Description
                  Text(description, classes: ["text-sm", "text-zinc-600", "dark:text-zinc-400", "max-w-xs", "md:max-w-none", "text-right", "md:text-left"])

                case .post(let title, _, let date, let keywords):
                  // Left: Title with metadata below
                  Stack {
                    Heading(.largeTitle, title, classes: ["text-2xl", "font-bold", "text-zinc-900", "dark:text-zinc-100", "mb-2"])
                    Stack(classes: ["flex", "items-center", "gap-2", "text-sm", "text-zinc-600", "dark:text-zinc-400"]) {
                      Text(date.formatAsMonthDayYear())
                      if !keywords.isEmpty {
                        Text("•")
                        Text(keywords.joined(separator: ", "))
                      }
                    }
                  }
                  // Right: Like button
                  Button(
                    onClick: "handleLike()",
                    classes: [
                      "p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400",
                      "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100",
                      "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer",
                    ],
                    label: "Like"
                  ) {
                    Icon(name: "heart", classes: ["w-5", "h-5"])
                  }

                case .photos(let albumName, let filterButtons):
                  // Left: Album Name
                  Heading(.largeTitle, albumName, classes: ["text-2xl", "font-bold", "text-zinc-900", "dark:text-zinc-100"])
                  // Right: Filter Buttons
                  if let filterButtons = filterButtons {
                    Stack(classes: ["flex", "items-center", "gap-2"]) {
                      MarkupString(content: filterButtons().map { $0.render() }.joined())
                    }
                  }

                case .tool(let name, let emoji, let controls):
                  // Left: Tool Name with emoji
                  Stack(classes: ["flex", "items-center", "gap-3"]) {
                    if let emoji = emoji {
                      Text(emoji, classes: ["text-2xl"])
                    }
                    Heading(.largeTitle, name, classes: ["text-2xl", "font-bold", "text-zinc-900", "dark:text-zinc-100"])
                  }
                  // Right: Tool Controls
                  if let controls = controls {
                    Stack(classes: ["flex", "items-center", "gap-2"]) {
                      MarkupString(content: controls().map { $0.render() }.joined())
                    }
                  }
                }
              }
            }

            // Main content container
            for item in content() {
              item
            }
          }
        }

        Footer(classes: [
          // Glassmorphic background
          "bg-white/80", "dark:bg-zinc-900/80",
          "backdrop-blur-xl", "backdrop-saturate-150",
          // Gradient border
          "border-t", "border-zinc-200/50", "dark:border-zinc-700/50",
          // Layout
          "px-4", "py-8", "space-y-4", "flex", "flex-col", "items-center", "justify-center",
          // Subtle shadow for depth
          "shadow-[0_-4px_16px_rgba(0,0,0,0.04)]", "dark:shadow-[0_-4px_16px_rgba(0,0,0,0.2)]",
        ]) {
          Stack(classes: ["flex", "flex-row", "items-center", "gap-3", "flex-wrap", "justify-center"]) {
            // Posts link
            Link(
              to: "/posts",
              classes: [
                "p-3", "text-zinc-600", "hover:text-teal-600",
                "dark:text-zinc-400", "dark:hover:text-teal-400",
                "rounded-xl",
                "bg-zinc-100/50", "dark:bg-zinc-800/50",
                "hover:bg-zinc-100", "dark:hover:bg-zinc-800",
                "border", "border-zinc-200/50", "dark:border-zinc-700/50",
                "transition-all", "duration-300", "cursor-pointer",
                "hover:scale-105", "hover:shadow-lg",
              ]
            ) { Icon(name: "file-text", classes: ["w-5", "h-5"]) }

            // Email link
            Link(
              to: "mailto:hello@maclong.uk",
              classes: [
                "p-3", "text-zinc-600", "hover:text-teal-600",
                "dark:text-zinc-400", "dark:hover:text-teal-400",
                "rounded-xl",
                "bg-zinc-100/50", "dark:bg-zinc-800/50",
                "hover:bg-zinc-100", "dark:hover:bg-zinc-800",
                "border", "border-zinc-200/50", "dark:border-zinc-700/50",
                "transition-all", "duration-300", "cursor-pointer",
                "hover:scale-105", "hover:shadow-lg",
              ]
            ) { Icon(name: "mail", classes: ["w-5", "h-5"]) }

            // GitHub link
            Link(
              to: "https://github.com/maclong9",
              newTab: true,
              classes: [
                "p-3", "text-zinc-600", "hover:text-teal-600",
                "dark:text-zinc-400", "dark:hover:text-teal-400",
                "rounded-xl",
                "bg-zinc-100/50", "dark:bg-zinc-800/50",
                "hover:bg-zinc-100", "dark:hover:bg-zinc-800",
                "border", "border-zinc-200/50", "dark:border-zinc-700/50",
                "transition-all", "duration-300", "cursor-pointer",
                "hover:scale-105", "hover:shadow-lg",
              ]
            ) { Icon(name: "github", classes: ["w-5", "h-5"]) }
          }

          Stack(classes: ["text-zinc-500", "dark:text-zinc-400", "text-sm", "font-medium"]) {
            Text("© \(Date().formatAsYear()) ")
            Link(
              "Mac Long",
              to: "https://maclong.uk",
              classes: [
                "hover:text-teal-600", "dark:hover:text-teal-400",
                "transition-colors", "duration-300",
                "font-semibold",
              ]
            )
            Text(".")
          }
        }

        // Mini Player for non-music pages
        MiniPlayer()
      }
    }
  }
}

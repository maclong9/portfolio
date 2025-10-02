import Foundation
import WebUI

/// Standard page layout component used across Posts, Photos, and Tools pages
/// Provides consistent header section with metadata and main content container
public struct StandardPageLayout: Element {
  let title: String
  let iconName: String
  let count: Int
  let countLabel: String
  let description: String
  let content: MarkupContentBuilder

  public init(
    title: String,
    iconName: String,
    count: Int,
    countLabel: String,
    description: String,
    @MarkupContentBuilder content: () -> some Markup
  ) {
    self.title = title
    self.iconName = iconName
    self.count = count
    self.countLabel = countLabel
    self.description = description
    self.content = content
  }

  public var body: some Markup {
    Stack(classes: ["max-w-4xl", "mx-auto"]) {
      // Page Header with inline metadata
      Stack(classes: ["mb-8"]) {
        Heading(.largeTitle, title, classes: ["text-3xl", "md:text-4xl", "font-bold", "mb-4"])

        Stack(classes: ["flex", "items-center", "justify-between", "flex-wrap", "gap-4"]) {
          // Left side: Count with icon
          Stack(classes: ["flex", "items-center", "gap-2", "text-sm"]) {
            Icon(name: iconName, classes: ["w-4", "h-4"])
            Text("\(count) \(countLabel)\(count == 1 ? "" : "s")")
          }

          // Right side: Description text
          Text(
            description,
            classes: ["text-sm", "text-zinc-600", "dark:text-zinc-400"]
          )
        }
      }

      // Main content container with liquid glass styling
      Stack(classes: ["p-8", "bg-gradient-to-br", "from-zinc-50/70", "to-white/70", "dark:from-zinc-900/70", "dark:to-zinc-800/70", "backdrop-blur-xl", "border", "border-white/50", "dark:border-white/10", "rounded-2xl", "shadow-sm"]) {
        content()
      }
    }
  }
}

import Foundation
import WebUI

/// Reusable empty state component for displaying "no content" messages
public struct EmptyState: Element {
  let iconName: String
  let title: String
  let message: String

  public init(
    iconName: String,
    title: String,
    message: String
  ) {
    self.iconName = iconName
    self.title = title
    self.message = message
  }

  public var body: some Markup {
    Stack(classes: [
      "max-w-4xl", "mx-auto", "text-center", "py-12",
      "bg-white/50", "dark:bg-zinc-800/50",
      "backdrop-blur-xl",
      "border", "border-white/50", "dark:border-white/10",
      "rounded-2xl", "shadow-sm"
    ]) {
      Icon(name: iconName, classes: ["w-12", "h-12", "mx-auto", "mb-4", "opacity-50"])
      Heading(.headline, title, classes: ["text-lg", "font-semibold", "mb-2"])
      Text(message, classes: ["opacity-75"])
    }
  }
}

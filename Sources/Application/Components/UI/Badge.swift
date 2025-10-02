import Foundation
import WebUI

/// Reusable badge component for tags, labels, and metadata
public struct Badge: Element {
  public enum Style {
    case neutral
    case teal
    case date
  }

  let text: String
  let style: Style

  public init(
    text: String,
    style: Style = .neutral
  ) {
    self.text = text
    self.style = style
  }

  public var body: some Markup {
    switch style {
    case .neutral:
      Text(
        text,
        classes: [
          "px-2.5", "py-1", "text-xs", "font-medium",
          "bg-zinc-100/80", "dark:bg-zinc-700/80",
          "backdrop-blur-sm",
          "rounded-full",
          "border", "border-zinc-200/50", "dark:border-zinc-600/50",
        ]
      )
    case .teal:
      Text(
        text,
        classes: [
          "px-3", "py-1.5", "text-xs",
          "bg-teal-50/80", "dark:bg-teal-950/50",
          "text-teal-700", "dark:text-teal-300",
          "backdrop-blur-sm",
          "rounded-full",
          "font-semibold",
          "border", "border-teal-200/50", "dark:border-teal-800/50",
        ]
      )
    case .date:
      Text(
        text,
        classes: [
          "text-sm", "text-zinc-600/90", "dark:text-zinc-400/90",
          "font-medium",
          "px-3", "py-1.5",
          "bg-white/80", "dark:bg-zinc-800/80",
          "backdrop-blur-sm",
          "rounded-full",
          "border", "border-zinc-200/50", "dark:border-zinc-700/50",
        ]
      )
    }
  }
}

import Foundation
import WebUI

/// Reusable link button component with consistent styling
public struct LinkButton: Element {
  let text: String
  let showArrow: Bool

  public init(
    text: String,
    showArrow: Bool = true
  ) {
    self.text = text
    self.showArrow = showArrow
  }

  public var body: some Markup {
    Text(
      showArrow ? "\(text) →" : text,
      classes: [
        "text-sm", "font-semibold",
        "text-teal-600", "dark:text-teal-400",
        "self-end",
        "px-4", "py-2",
        "bg-teal-50/80", "dark:bg-teal-950/30",
        "backdrop-blur-sm",
        "rounded-full",
        "border", "border-teal-200/50", "dark:border-teal-800/50",
      ]
    )
  }
}

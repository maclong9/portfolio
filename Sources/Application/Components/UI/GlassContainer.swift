import Foundation
import WebUI

/// Reusable glass morphism container component
public struct GlassContainer: Element {
  let content: MarkupContentBuilder
  let additionalClasses: [String]

  public init(
    additionalClasses: [String] = [],
    @MarkupBuilder content: @escaping MarkupContentBuilder
  ) {
    self.content = content
    self.additionalClasses = additionalClasses
  }

  public var body: some Markup {
    Stack(
      classes: [
        "p-8",
        "bg-gradient-to-br", "from-zinc-50/70", "to-white/70",
        "dark:from-zinc-900/70", "dark:to-zinc-800/70",
        "backdrop-blur-xl",
        "border", "border-white/50", "dark:border-white/10",
        "rounded-2xl", "shadow-sm",
      ] + additionalClasses
    ) {
      MarkupString(content: content().map { $0.render() }.joined())
    }
  }
}

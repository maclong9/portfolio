import Foundation
import WebUI

struct Tools: Document {
  var path: String? { "tools" }

  var metadata: Metadata {
    Metadata(from: Application().metadata, title: "Tools")
  }

  // MARK: - Tools Data
  struct Tool {
    let title: String
    let description: String
    let icon: String
    let path: String
  }

  let tools: [Tool] = [
    Tool(
      title: "Barre Scales",
      description: "Interactive guitar scale trainer with CAGED positions and chord progressions",
      icon: "🎸",
      path: "/tools/barre-scales"
    ),
    Tool(
      title: "Schengen Tracker",
      description: "Track your Schengen 90/180 day visa limits with calendar integration",
      icon: "🗺️",
      path: "/tools/schengen-tracker"
    ),
  ]

  var body: some Markup {
    Layout(
      path: "tools",
      title: "Tools - Mac Long",
      description: "Collection of web-based utility tools",
      breadcrumbs: [
        Breadcrumb(title: "Mac Long", url: "/"),
        Breadcrumb(title: "Tools", url: "/tools"),
      ]
    ) {
      Stack(classes: ["max-w-4xl", "mx-auto"]) {
        // Page Header with inline metadata
        Stack(classes: ["mb-8"]) {
          Heading(.largeTitle, "Tools", classes: ["text-3xl", "md:text-4xl", "font-bold", "mb-4"])

          Stack(classes: ["flex", "items-center", "justify-between", "flex-wrap", "gap-4"]) {
            // Left side: Tool count with icon
            Stack(classes: ["flex", "items-center", "gap-2", "text-sm"]) {
              Icon(name: "wrench", classes: ["w-4", "h-4"])
              Text("\(tools.count) tool\(tools.count == 1 ? "" : "s")")
            }

            // Right side: Info text
            Text(
              "Utility collection for everyday tasks.",
              classes: ["text-sm", "text-zinc-600", "dark:text-zinc-400"]
            )
          }
        }

        // Tools Grid with container
        Stack(classes: ["p-8", "bg-gradient-to-br", "from-zinc-50/70", "to-white/70", "dark:from-zinc-900/70", "dark:to-zinc-800/70", "backdrop-blur-xl", "border", "border-white/50", "dark:border-white/10", "rounded-2xl", "shadow-sm"]) {
          CardCollection(
            cards: tools.map { tool in
              Card(
                title: tool.title,
                description: tool.description,
                linkURL: tool.path,
                linkText: "Open tool",
                emoji: tool.icon
              )
            }
          )
        }
      }
    }
  }
}

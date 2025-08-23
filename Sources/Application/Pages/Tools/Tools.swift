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
        // Page Header
        Stack(classes: ["text-center", "mb-12"]) {
          Heading(.largeTitle, "🛠️ Tools", classes: ["text-3xl", "md:text-4xl", "font-bold", "mb-4"])
          Text(
            "Utility collection for everyday tasks.",
            classes: ["text-lg", "max-w-2xl", "mx-auto"]
          )
        }

        // Tools Grid
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

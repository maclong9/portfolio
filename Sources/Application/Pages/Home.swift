import Foundation
import WebUI

struct Home: Document {
  var path: String? { "index" }

  var metadata: Metadata {
    Metadata(from: Application().metadata, title: "Mac Long - Developer")
  }

  // MARK: - Skill Cards
  let skillsCards: [Card] = [
    Card(
      title: "Apple Ecosystem",
      description:
        "Building native iOS and macOS experiences using Swift and SwiftUI — elegant, fast, and deeply integrated with the platform.",
      tags: ["Swift", "SwiftUI", "Xcode", "iOS", "macOS", "UIKit", "Combine", "CoreData"],
      emoji: "📱"
    ),
    Card(
      title: "Systems Programming",
      description:
        "Crafting efficient tools and low-level systems with C and Swift — understanding UNIX internals, memory, and process control.",
      tags: ["C", "Swift", "UNIX", "POSIX", "Shell", "CLI", "Make", "Clang"],
      emoji: "🔧"
    ),
    Card(
      title: "Web Development",
      description:
        "Creating full-stack web applications with clean HTML, modern CSS, and Swift-powered backends for speed and scalability.",
      tags: ["HTML", "CSS", "JavaScript", "Hummingbird", "REST", "SSE", "WebSockets", "Caching"],
      emoji: "🌐"
    ),
    Card(
      title: "Cloud & DevOps",
      description:
        "Automating deployment, managing infrastructure, and optimizing edge delivery with reliable, self-managed systems.",
      tags: ["Cloudflare", "Docker", "GitHub", "CI/CD", "Git", "VPS", "Apache", "Monitoring"],
      emoji: "☁️"
    ),
  ]

  // MARK: - Skill Cards
  let projectCards: [Card] = [
    Card(
      title: "Guest List - 🚧",
      description:
        "Full stack web application with iOS app for gig venues and music fans.",
      tags: ["Hummingbird", "WebUI", "SwiftUI"],
      linkURL: "https://github.com/maclong9/guest-list",
      linkText: "View here",
      newTab: true,
      emoji: "📋",
    ),
    Card(
      title: "Tools Collection",
      description:
        "Modern utility tools built with WebUI for guitar training, travel planning and more.",
      tags: ["WebUI", "Swift", "Cloudflare"],
      linkURL: "/tools",
      linkText: "Open Tools",
      emoji: "🛠️",
    ),
    Card(
      title: "List",
      description:
        "A modern Swift reimplementation of the UNIX ls command with colorized output and enhanced formatting.",
      tags: ["Swift", "CLI", "macOS"],
      linkURL: "https://github.com/maclong9/list",
      linkText: "View on GitHub",
      newTab: true,
      emoji: "🗂️",
    ),
    Card(
      title: "WebUI",
      description:
        "A Swift library for generating type-safe web user interfaces with consistency and ease of use.",
      tags: ["Swift", "TailwindCSS", "SSG"],
      linkURL: "https://github.com/maclong9/web-ui",
      linkText: "View on GitHub",
      newTab: true,
      emoji: "🌐",
    ),
  ]

  // MARK: - Body
  var body: some Markup {
    Layout(
      path: "index",
      title: "Mac Long - Developer Portfolio",
      description: "Full-stack developer specializing in modern web technologies"
    ) {
      Stack(classes: ["max-w-4xl", "mx-auto", "space-y-16"]) {
        // Hero
        Section(classes: ["text-center", "mb-16"]) {
          Stack(classes: ["relative"]) {
            GameOfLife()
            Stack(classes: ["text-center", "z-20", "max-w-xl", "mx-auto", "text-balance"]) {
              Image(
                source: "https://avatars.githubusercontent.com/u/115668288?v=4",
                description: "Mac Long"
              )
              .frame(width: .spacing(24), height: .spacing(24))
              .addClasses([
                "rounded-full", "border-2", "border-teal-400", "shadow-lg",
                "mx-auto", "mb-6", "hero-avatar",
              ])

              Heading(.largeTitle, "Mac Long")
                .addClasses(["text-4xl", "md:text-5xl", "font-bold", "mb-4", "hero-name"])

              Text("Passionate about creating modern software experiences with clean code and thoughtful design.")
                .addClasses([
                  "text-xl", "mb-8", "mx-auto",
                  "hero-description",
                ])
            }
          }
        }

        // Skills Section
        Section(classes: ["mb-16"]) {
          Heading(.title, "Technologies & Skills", classes: ["text-2xl", "font-bold", "mb-8", "text-center"])
          CardCollection(cards: skillsCards)
        }

        // Projects Section
        Section(classes: ["mb-16"]) {
          Heading(.title, "Recent Projects", classes: ["text-2xl", "font-bold", "mb-8", "text-center"])
          CardCollection(cards: projectCards)
        }
      }
    }
  }
}

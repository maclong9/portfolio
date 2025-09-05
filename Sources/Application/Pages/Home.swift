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
        "Native iOS and macOS development using Swift and SwiftUI for beautiful, performant applications.",
      tags: ["Swift", "SwiftUI", "Xcode", "iOS", "macOS", "App Store", "UIKit", "Core Data", "TestFlight"],
      emoji: "📱"
    ),
    Card(
      title: "Cloud & DevOps",
      description: "Modern deployment and infrastructure management with automated CI/CD and cloud hosting.",
      tags: ["Cloudflare", "Vercel", "AWS", "GitHub", "Docker", "CI/CD", "Kubernetes", "Git"],
      emoji: "☁️"
    ),
    Card(
      title: "Frontend",
      description:
        "Creating responsive, interactive web experiences with modern frameworks and cutting-edge styling.",
      tags: ["React", "Next.js", "TypeScript", "TailwindCSS", "Alpine.js", "HTML5", "CSS3", "HTMX", "Vite"],
      emoji: "🖥️"
    ),
    Card(
      title: "Backend",
      description:
        "Building scalable server-side applications and APIs with robust databases and efficient data management.",
      tags: ["Swift", "Node.js", "Express", "PostgreSQL", "Redis", "REST APIs", "Websockets", "Hummingbird"],
      emoji: "⚙️"
    ),
  ]

  // MARK: - Skill Cards
  let projectCards: [Card] = [
    Card(
      title: "Constellate - 🚧",
      description:
        "Full stack SaaS application for increasing productivity among startups and small teams.",
      tags: ["Swift", "WebUI", "SwiftUI"],
      linkURL: "https://github.com/maclong9/constellate",
      linkText: "View here",
      newTab: true,
      emoji: "✨",
    ),
    Card(
      title: "Tools Collection",
      description:
        "Modern utility tools built with TailwindCSS and Alpine.js for guitar training and travel planning.",
      tags: ["TailwindCSS", "Alpine.js", "Cloudflare"],
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
      tags: ["Swift", "TailwindCSS", "Static Sites"],
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
            ParticleNetwork()
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

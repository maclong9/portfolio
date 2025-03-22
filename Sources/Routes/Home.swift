import Foundation
import WebUI

struct Home: HTML {
  func render() -> String {
    RootLayout(isHome: true) {
      Hero(
        image: true,
        heading: "Software engineer, skater, and amateur musician.",
        text:
          "I’m Mac, a software engineer based out of the United Kingdom. I enjoy working on open source projects and building things that make people’s lives easier.",
        socials: [
          .init(icon: "I", url: "https://instagram.com/mac9sb/"),
          .init(icon: "G", url: "https://github.com/maclong9"),
        ]
      )
      Section {
        List {
          // for loop with blog posts
        }
        Aside {
          Text { "💼 Work" }
          List {
            // for loop of experience
          }
          Link(to: "/mac-long-swe-cv.pdf") { "Download CV ↓" }
        }
      }
    }.render()
  }
}

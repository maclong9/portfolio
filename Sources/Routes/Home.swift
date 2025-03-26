import Foundation
import WebUI

struct Home: HTML {
  struct Experience {
    let icon: String
    let title: String
    let position: String
    let startDate: String
    let endDate: String
  }

  let experience: [Experience] = [
    Experience(
      icon: "I",
      title: "3 Sided Cube",
      position: "Software Engineer",
      startDate: "2022-10-16",
      endDate: "2024-06-31"
    ),
    Experience(
      icon: "I",
      title: "Quantum",
      position: "Software Engineer",
      startDate: "2024-07-12",
      endDate: "present"
    ),
  ]

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
        ArticlesList()
        Aside {
          Text { "💼 Work" }
          List {
            for job in experience {
              job.icon
              Stack {
                job.title
                job.position
              }
              Text {
                "\(job.startDate) – \(job.endDate)"
              }

            }
          }
          Link(to: "/mac-long-swe-cv.pdf") { "Download CV ↓" }
        }
      }
    }.render()
  }
}

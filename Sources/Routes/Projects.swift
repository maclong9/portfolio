import Foundation
import WebUI

struct Projects: HTML {
  struct Project {
    let icon: String
    let title: String
    let description: String;
    let link: String
  }

  let projects: [Project] = [
    Project(
      icon: "I",
      title: "List",
      description: "Quickly list files found in your operating system, Swift recreation of the UNIX command ls.",
      link: "https://github.com/maclong9/list"
    ),
    Project(
      icon: "I",
      title: "WebUI",
      description: "Render web pages and static sites in Swift, using a SwiftUI like pattern.",
      link: "https://github.com/maclong9/web-ui"
    ),
    Project(
      icon: "I",
      title: "Todos",
      description: "Full stack todo list application with authentication, built using Swift Hummingbird and WebUI.",
      link: "https://github.com/maclong9/todos"
    ),
  ]

  func render() -> String {
    RootLayout {
      Hero(
        heading: "A small collection of projects I've worked on.",
        text:
          "I’ve worked on tons of little projects over the years but these are the ones that I’m most proud of. Many of them are open-source, so if you see something that piques your interest, check out the code and contribute if you have ideas for how it can be improved."
      )
      Section {
        List {
          for project in projects {
            Card(
              icon: project.icon,
              title: project.title,
              description: project.description,
              url: project.link
            )
          }
        }
      }
    }.render()
  }
}

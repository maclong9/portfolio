import Foundation
import WebUI

struct Project {
  let name: String
  let description: String
  let technologies: [String]
  let url: String
}

struct Projects: HTML {
  let projects: [Project] = [
    Project(
      name: "WebUI",
      description: "WebUI is a rendering library for HTML, CSS, and JavaScript, built entirely in Swift.",
      technologies: ["Swift"],
      url: "https://github.com/maclong9/web-ui"
    ),
    Project(
      name: "Todos",
      description: "Full stack todo list implimentation.",
      technologies: ["Swift", "Hummingbird", "WebUI"],
      url: "https://github.com/maclong9/todos"
    ),
  ]

  func render() -> String {
    Layout {
      Heading(level: .one) { "Recent Projects" }
        .styled(size: .xl4)
        .margins(.bottom)
      
      Stack {
        for project in projects {
          Card(
            title: project.name,
            url: project.url,
            description: project.description,
            technologies: project.technologies,
            publishedDate: nil
          )
        }
      }.flex(direction: .column).padding(length: 10).spaced()
    }.render()
  }
}

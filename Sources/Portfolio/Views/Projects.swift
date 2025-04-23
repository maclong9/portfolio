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
      name: "Todos",
      description: "Full stack todo list implimentation.",
      technologies: ["Swift", "Hummingbird", "WebUI"],
      url: "https://github.com/maclong9/todos"
    ),
    Project(
      name: "WebUI",
      description: "WebUI is a rendering library for HTML, CSS, and JavaScript, built entirely in Swift.",
      technologies: ["Swift"],
      url: "https://github.com/maclong9/web-ui"
    ),
  ]

  func render() -> String {
    Layout {
      Heading(level: .one) { "Recent Projects" }
        .styled(size: .xl4)
        .margins(.bottom)
      Text {
        "Below are a list of projects I have worked on recently as well as links to their source code, they usually range from development tools to full stack applications."
      }.font(family: "ui-serif")

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
      }.flex(direction: .column).padding(length: 10).margins(.vertical)
    }.render()
  }
}

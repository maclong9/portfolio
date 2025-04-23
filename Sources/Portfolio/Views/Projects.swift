import Foundation
import WebUI

struct Project: CardItem {
  let name: String
  let description: String
  let technologies: [String]?
  let url: String

  var title: String { name }
  var publishedDate: Date? { nil }
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
      PageHeader(
        title: "Recent Projects",
        description:
          "Below are a list of projects I have worked on recently as well as links to their source code, they usually range from development tools to full stack applications."
      )
      Collection(items: projects)
    }.render()
  }
}

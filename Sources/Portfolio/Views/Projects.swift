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
      name: "WebUI",
      description:
        "WebUI is a rendering library for HTML, CSS, and JavaScript, built entirely in Swift.",
      technologies: ["Swift"],
      url: "https://github.com/maclong9/web-ui",
    ),
    Project(
      name: "List",
      description: "Quickly list files found in your operating system",
      technologies: ["Swift"],
      url: "https://github.com/maclong9/list",
    ),
  ]
  var document: Document {
    .init(
      path: "projects",
      metadata: .init(
        site: Portfolio.author,
        title: "Projects",
        description: "Software Engineer, crafting intuitive solutions.",
        image: "/public/og.jpg",
        author: Portfolio.author,
        type: .website,
      ),
      head: "<link rel=\"icon\" href=\"/public/icon.svg\" type=\"image/svg+xml\" />",
      content: { self },
    )
  }

  func render() -> String {
    Layout(
      title: "Recent Projects",
      description:
        "Below are a list of projects I have worked on recently as well as links to their source code, they usually range from development tools to full stack applications.",
    ) {
      Collection(items: projects)
    }.render()
  }
}

import Foundation
import WebUI

struct Project: CardItem {
    let name: String
    let description: String
    let tags: [String]?
    let url: String
    var title: String { name }
    var publishedDate: Date? { nil }
}

struct Projects: HTML {
    let projects: [Project] = [
        Project(
            name: "WebUI",
            description:
                "WebUI is a library for HTML, CSS, and JavaScript generation built entirely in Swift.",
            tags: ["Swift"],
            url: "https://github.com/maclong9/web-ui",
        ),
        Project(
            name: "List",
            description: "Quickly list files found in your operating system from the command line.",
            tags: ["Swift"],
            url: "https://github.com/maclong9/list",
        ),
    ]

    var document: Document {
        .init(
            path: "projects",
            metadata: Metadata(from: Application.metadata, title: "About"),
            content: { self }
        )
    }

    func render() -> String {
        Layout(
            title: "Recent Projects",
            description:
                "Below are a list of projects I have worked on recently as well as links to their source code, they usually range from development tools to full stack applications."
        ) {
            Collection(items: projects)
        }.render()
    }
}

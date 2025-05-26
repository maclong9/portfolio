import Foundation
import Shared
import WebUI

struct Project: CardItem {
    let name: String
    let description: String
    let tags: [String]?
    let url: String
    let newTab: Bool = true
    let action: CardAction = .sourceCode
    var title: String { name }
    var publishedDate: Date? { nil }
}

struct Projects: Document {
    var metadata: Metadata {
        Metadata(from: Application().metadata, title: "Projects")
    }

    var path: String? {
        "projects"
    }

    let projects: [Project] = [
        Project(
            name: "WebUI",
            description: "WebUI is a library for HTML, CSS, and JavaScript generation built entirely in Swift.",
            tags: ["Swift"],
            url: "https://github.com/maclong9/web-ui"
        ),
        Project(
            name: "List",
            description: "Quickly list files found in your operating system from the command line.",
            tags: ["Swift"],
            url: "https://github.com/maclong9/list"
        ),
    ]

    var body: some HTML {
        Layout(
            title: "Recent Projects",
            description:
                "Below are a list of projects I have worked on recently as well as links to their source code, they usually range from development tools to full stack applications."
        ) {
            CardCollection(items: projects)
        }
    }
}

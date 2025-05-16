import WebUI

struct Projects: HTML {
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
            Section {

            }
        }.render()
    }
}

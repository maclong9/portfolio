import WebUI

struct Missing: HTML {
    var document: Document {
        .init(
            path: "404",
            metadata: Metadata(from: Application.metadata, title: "404 - Page Not Found"),
            content: { self }
        )
    }

    func render() -> String {
        Layout(
            title: "404 - Page Not Found",
            description:
                "Whoops, unfortunately that page either no longer or never existed in the first place..."
        ) {
          Link(to: "/") { "Head back home?" }.styled()
        }.render()
    }
}

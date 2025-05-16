import WebUI

struct Home: HTML {
    var document: Document {
        .init(
            path: "",
            metadata: Metadata(from: Application.metadata, title: "Home"),
            content: { self }
        )
    }

    func render() -> String {
        Layout(
            title: "Software Engineer, Skater & Musician",
            description:
                "I'm Mac, a software engineer based out of the United Kingdom. I enjoy building robust and efficient software. Read some of my articles below."
        ) {
            Section {
            }
            .spacing(of: 4, along: .y)
            .margins(at: .horizontal, auto: true)
        }.render()
    }
}

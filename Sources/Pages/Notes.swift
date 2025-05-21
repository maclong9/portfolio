import Foundation
import WebUI

struct Note: CardItem {
    let name: String
    let description: String
    let tags: [String]?
    let url: String
    var title: String { name }
    var publishedDate: Date? { nil }
}

struct Notes: HTML {
    var document: Document {
        .init(
            path: "notes",
            metadata: Metadata(from: Application.metadata, title: "Notes"),
            content: { self }
        )
    }

    let notes: [Note] = [
        Note(
            name: "Computer Science",
            description:
                "My notes from following along with https://teachyourselfcs.com, a course recommended for furthering Computer Science knowledge",
            tags: ["comp-sci"],
            url: "https://notes.maclong.uk/comp-sci",
        )
    ]

    func render() -> String {
        Layout(
            title: "Notes",
            description:
                "I like to take notes of courses and things I find interesting. Here is a collection of them for you to read."
        ) {
            Collection(items: notes)
        }.render()
    }
}

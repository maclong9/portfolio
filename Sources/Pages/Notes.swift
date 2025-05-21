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
    let notes: [Note] = [
        Note(
            name: "Computer Science",
            description:
                "My notes from following along with https://teachyourselfcs.com and some bonus Harvard CS50 notes.",
            tags: ["comp-sci"],
            url: "https://notes.maclong.uk/comp-sci",
        )
    ]

    var document: Document {
        .init(
            path: "notes",
            metadata: Metadata(from: Application.metadata, title: "Notes"),
            content: { self }
        )
    }

    func render() -> String {
        Layout(
            title: "Notes",
            description:
                "I like to take notes of courses and things I find interesting. Here is a collection of them."
        ) {
            Collection(items: notes)
        }.render()
    }
}

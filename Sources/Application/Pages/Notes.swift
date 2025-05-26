import Foundation
import Shared
import WebUI

struct Note: CardItem {
    let name: String
    let description: String
    let tags: [String]?
    let url: String
    let newTab: Bool = false
    let action: CardAction = .readMore
    var title: String { name }
    var publishedDate: Date? { nil }
}

struct Notes: Document {
    var metadata: Metadata {
        Metadata(from: Application().metadata, title: "Notes")
    }

    var path: String? {
        "notes"
    }

    let notes: [Note] = [
        Note(
            name: "Computer Science",
            description:
                "My notes from following along with Teach Yourself Computer Science, a course recommended for furthering knowledge in comp-sci.",
            tags: ["comp-sci"],
            url: "https://notes.maclong.uk/comp-sci"
        )
    ]

    var body: some HTML {
        Layout(
            path: path,
            title: "Notes",
            description:
                "I like to take notes of courses and things I find interesting. Here is a collection of them for you to read.",
        ) {
            CardCollection(items: notes)
        }
    }
}

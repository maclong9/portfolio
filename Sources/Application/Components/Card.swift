import Foundation
import WebUI

public struct CardCollection: Element {
    let cards: [Card]

    public var body: some Markup {
        Stack(classes: ["grid", "md:grid-cols-2", "gap-6", "max-w-4xl", "mx-auto", "auto-rows-min"]) {
            for card in cards { card }
        }
    }
}

public struct Card: Element {
    public let title: String
    public let description: String
    public let tags: [String]

    public let linkURL: String?
    public let linkText: String?
    public let newTab: Bool

    public let emoji: String?
    public let publishedDate: Date?

    public init(
        title: String,
        description: String,
        tags: [String] = [],
        linkURL: String? = nil,
        linkText: String? = nil,
        newTab: Bool = false,
        emoji: String? = nil,
        publishedDate: Date? = nil
    ) {
        self.title = title
        self.description = description
        self.tags = tags
        self.linkURL = linkURL
        self.linkText = linkText
        self.newTab = newTab
        self.emoji = emoji
        self.publishedDate = publishedDate
    }

    public var body: some Markup {
        let cardContent = Stack(classes: [
            "flex", "flex-col", "justify-center", "bg-white", "dark:bg-zinc-800", "rounded-lg",
            "shadow-sm", "border", "border-zinc-200", "dark:border-zinc-700", "p-6",
            "hover:shadow-lg", "hover:shadow-teal-500/20",
            "dark:hover:shadow-teal-400/20",
            "transition-all", "duration-300", "cursor-pointer", "card", "min-h-[220px]",
        ]) {

            // Header row: icon/emoji + tags
            Stack(classes: ["flex", "items-start", "justify-between", "mb-4"]) {
                if let emoji {
                    Stack(classes: [
                        "w-12", "h-12", "bg-teal-100", "dark:bg-teal-900",
                        "rounded-lg", "flex", "items-center", "justify-center",
                    ]) {
                        Text(emoji, classes: ["text-2xl"])
                    }
                }

                if !tags.isEmpty && tags.count <= 3 {
                    Stack(classes: ["flex", "flex-wrap", "gap-1"]) {
                        for tag in tags {
                            Text(
                                tag,
                                classes: [
                                    "px-2", "py-1", "text-xs",
                                    "bg-zinc-100", "dark:bg-zinc-700",
                                    "rounded",
                                ]
                            )
                        }
                    }
                }
            }

            // Main content: meta/date, title, description
            Stack(classes: ["flex", "flex-col"]) {
                if let date = publishedDate {
                    Time(
                        datetime: date.ISO8601Format(),
                        id: "\(date.formatted(date: .abbreviated, time: .omitted))",
                        classes: [
                            "text-sm", "text-zinc-600/90", "dark:text-zinc-400/90", "mb-2",
                        ]
                    )
                }

                Heading(
                    .headline,
                    title,
                    classes: [
                        "text-lg", "font-semibold", "mb-3", "transition-colors",
                    ]
                )

                if !description.isEmpty {
                    Text(
                        description,
                        classes: [
                            "text-sm", "mb-4", "flex-1",

                        ]
                    )
                }

                // Footer: tags + link text
                Stack(classes: ["mt-auto"]) {
                    if tags.count > 3 {
                        Stack(classes: ["flex", "flex-wrap", "gap-2", "mb-3"]) {
                            for tag in tags {
                                Text(
                                    tag,
                                    classes: [
                                        "px-2", "py-1", "text-xs",
                                        "bg-zinc-100", "dark:bg-zinc-700",

                                        "rounded",
                                    ]
                                )
                            }
                        }
                    }

                    if let linkText {
                        Text(
                            linkText,
                            classes: [
                                "text-sm", "font-medium",
                                "text-teal-700", "dark:text-teal-300",
                                "self-end",
                            ]
                        )
                    }
                }
            }
        }

        if let url = linkURL {
            return AnyMarkup(
                Link(to: url, newTab: newTab) {
                    cardContent
                }
            )
        } else {
            return AnyMarkup(cardContent)
        }
    }
}

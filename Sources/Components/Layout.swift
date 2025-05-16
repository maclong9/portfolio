import Foundation
import WebUI

struct PageHeader: HTML {
    let title: String
    let description: String
    let published: Date?

    func render() -> String {
        Stack {
            Heading(.title) { title }
            if let published = published {
                Text {
                    Text { "Published: " }
                    "\(published.formatted(date: .complete, time: .omitted))"
                }
            }
            Text { description }
        }
        .flex(direction: .column)
        .render()
    }
}

struct Layout: HTML {
    let title: String
    let description: String
    let published: Date?
    let children: Children

    init(
        title: String,
        description: String,
        published: Date? = nil,
        @HTMLBuilder children: @escaping HTMLContentBuilder
    ) {
        self.title = title
        self.description = description
        self.published = published
        self.children = Children(content: children)
    }

    public func render() -> String {
        Stack {
            Header {
                Link(to: "/") { "Mac Long" }
                Navigation {
                    Link(to: "/projects") { "Projects" }
                    Link(to: "https://github.com/maclong9", newTab: true, label: "Visit Mac Long's GitHub profile") {
                        Text { Icon.github.rawValue }
                    }
                    .frame(width: 8, height: 8)
                    .flex(justify: .center, align: .center)
                }.flex(align: .center).spacing(of: 2, along: .x)
            }
            .flex(justify: .between, align: .center)
            .frame(width: .full, maxWidth: .character(86))
            .margins(at: .bottom)
            .margins(at: .horizontal, auto: true)
            .padding(at: .vertical)

            Main {
                PageHeader(
                    title: title,
                    description: description,
                    published: published,
                )
                children.render()
            }
            .flex(grow: .one)
            .margins(at: .horizontal, auto: true)
            .frame(maxWidth: .character(67), on: .sm)

            Footer {
                Text {
                    "© \(Date().formattedYear()) "
                    Link(to: "/") { "Mac Long" }
                }
            }
            .font(size: .sm, color: .zinc(._600, opacity: 0.9))
            .font(color: .zinc(._400, opacity: 0.9), on: .dark)
            .flex(justify: .center, align: .center)
            .padding(at: .vertical)
        }
        .frame(minHeight: .screen)
        .font(color: .zinc(._800))
        .background(color: .zinc(._200))
        .font(color: .zinc(._200), on: .dark)
        .background(color: .zinc(._950), on: .dark)
        .flex(direction: .column)
        .render()
    }
}

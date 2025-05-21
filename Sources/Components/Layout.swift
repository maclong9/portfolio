import Foundation
import WebUI

struct PageHeader: HTML {
    let title: String
    let description: String
    let published: Date?

    func render() -> String {
        Stack {
            Heading(.largeTitle) { title }
                .styled(size: .xl4)
            if let published = published {
                Text {
                    Text { "Published: " }.font(weight: .bold, family: "system-ui")
                    "\(published.formatted(date: .complete, time: .omitted))"
                }
            }
            Text { description }
        }
        .flex(direction: .column)
        .spacing(of: 4, along: .y)
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
            Header(classes: ["backdrop-blur-3xl"]) {
                Link(to: "/") { "Mac Long" }.styled()
                Navigation {
                    Link(to: "/projects") { "Projects" }.styled()
                    Link(to: "notes.maclong.uk") { "Notes" }.styled()
                    Link(to: "https://github.com/maclong9", newTab: true, label: "Visit Mac Long's GitHub profile") {
                        Text { Icon.github.rawValue }
                    }
                    .styled()
                    .rounded(.lg)
                    .transition(of: .colors)
                    .frame(width: 8, height: 8)
                    .flex(justify: .center, align: .center)
                    .background(color: .zinc(._300), on: .hover)
                    .background(color: .zinc(._700), on: .hover, .dark)
                }.flex(align: .center).spacing(of: 2, along: .x)
            }
            .flex(justify: .between, align: .center)
            .frame(width: .screen, maxWidth: .character(100))
            .margins(at: .horizontal, auto: true)
            .margins(at: .bottom)
            .border(at: .bottom, color: .zinc(._900, opacity: 0.5))
            .border(at: .bottom, color: .zinc(._500, opacity: 0.7), on: .dark)
            .padding(at: .horizontal)
            .padding(of: 2, at: .vertical)
            .position(.fixed, at: .horizontal, .top, offset: 0)
            .background(color: .zinc(._200, opacity: 0.5))
            .background(color: .zinc(._950, opacity: 0.5), on: .dark)
            .zIndex(50)

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
            .frame(maxWidth: .custom("99vw"))
            .frame(maxWidth: .character(76), on: .sm)
            .font(wrapping: .pretty)
            .padding()
            .padding(of: 20, at: .top)

            Footer {
                Text {
                    "© \(Date().formattedYear()) "
                    Link(to: "/") { "Mac Long" }.styled(weight: .normal)
                }
            }
            .font(size: .sm, color: .zinc(._600, opacity: 0.9))
            .font(color: .zinc(._400, opacity: 0.9), on: .dark)
            .flex(justify: .center, align: .center)
            .padding(at: .vertical)
        }
        .flex(direction: .column)
        .frame(minHeight: .screen)
        .font(color: .zinc(._800), family: "ui-serif")
        .background(color: .zinc(._200))
        .font(color: .zinc(._200), on: .dark)
        .background(color: .zinc(._950), on: .dark)
        .render()
    }
}

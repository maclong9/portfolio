import Foundation
import WebUI

public struct Layout: Element {
    let path: String?
    let title: String
    let description: String
    let published: Date?
    let content: HTMLContentBuilder

    public init(
        path: String? = nil,
        title: String,
        description: String,
        published: Date? = nil,
        @HTMLBuilder content: @escaping HTMLContentBuilder
    ) {
        self.path = path
        self.title = title
        self.description = description
        self.published = published
        self.content = content
    }

    // Computed property to determine the correct link URL
    private var linkURL: String {
        guard let path = path, path == "Article" else { return "" }
        return "https://notes.maclong.uk/\(path)"
    }

    // Computed property to determine the display text
    private var linkText: String {
        guard let path = path else { return "" }
        return path == "Article" ? "Home" : path.capitalized
    }

    public var body: some HTML {
        BodyWrapper {
            Header(classes: ["backdrop-blur-3xl"]) {
                Stack {
                    Link(to: "https://maclong.uk/") {
                        "Mac Long"
                    }.styled()
                    if path != nil {
                        Text { "/" }
                        Link(to: linkURL) { linkText }.styled()
                    }
                }.flex(align: .center).spacing(of: 2, along: .horizontal)
                Navigation {
                    Link(to: "/projects") { "Projects" }.styled()
                    Link(to: "https://notes.maclong.uk", newTab: false) { "Notes" }.styled()
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
                }.flex(align: .center).spacing(of: 2, along: .horizontal)
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

            Main(classes: ["flex-1"]) {
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
                .spacing(of: 4, along: .vertical)

                HTMLString(content: content().map { $0.render() }.joined())
            }
            .margins(at: .horizontal, auto: true)
            .frame(maxWidth: .custom("99vw"))
            .frame(maxWidth: .character(76), on: .sm)
            .font(wrapping: .pretty)
            .padding()
            .padding(of: 20, at: .top)

            Footer {
                Text {
                    "© \(Date().formatAsYear()) "
                    Link(to: "/") { "Mac Long" }.styled(weight: .normal)
                }
            }
            .font(size: .sm, color: .zinc(._600, opacity: 0.9), family: "system-ui")
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
        .position(.relative)
    }
}

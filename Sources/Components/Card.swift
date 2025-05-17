import Foundation
import WebUI

protocol CardItem {
    var title: String { get }
    var url: String { get }
    var description: String { get }
    var technologies: [String]? { get }
    var publishedDate: Date? { get }
}

struct Card: HTML, CardItem {
    let title: String
    let url: String
    let description: String
    let technologies: [String]?
    let publishedDate: Date?

    func render() -> String {
        Link(to: url, newTab: technologies != nil) {
            Article {
                Stack {
                    Heading(.title) { title }.styled(size: .xl2)

                    if let technologies = technologies {
                        Stack {
                            for technology in technologies {
                                Text { technology }
                                    .background(color: .zinc(._300))
                                    .background(color: .zinc(._800), on: .dark)
                                    .rounded(.lg)
                                    .font(size: .xs, color: .zinc(._900), family: "system-ui")
                                    .font(color: .zinc(._200), on: .dark)
                                    .padding(EdgeInsets(vertical: 1, horizontal: 2))
                                    .margins(of: 2, at: .horizontal)
                            }
                        }
                    }
                }
                .flex(direction: .row, align: .center)

                if let date = publishedDate {
                    Time(datetime: "\(date.ISO8601Format())") {
                        "\(date.formatted(date: .complete, time: .omitted))"
                    }
                    .font(size: .sm, color: .zinc(._600, opacity: 0.9))
                    .font(color: .zinc(._400, opacity: 0.9), on: .dark)
                }

                Text { description }
                    .margins(of: 2, at: .top)
                    .margins(of: 3, at: .bottom)

                Text { "\(technologies == nil ? "Read more" :"Source code") ›" }
                    .font(size: .sm, weight: .semibold, color: .teal(._800), family: "system-ui")
                    .font(color: .teal(._500), on: .dark)
            }
            .cursor(.pointer)
            .flex(direction: .column, align: .start)
            .rounded(.lg)
            .background(color: .zinc(._300), on: .hover)
            .background(color: .zinc(._700), on: .hover, .dark)
            .transition(of: .colors, for: 300, easing: .inOut)
            .padding()
        }.render()
    }
}

struct Collection<T: CardItem>: HTML {
    let items: [T]

    func render() -> String {
        Stack {
            for item in items {
                Card(
                    title: item.title,
                    url: item.url,
                    description: item.description,
                    technologies: item.technologies,
                    publishedDate: item.publishedDate
                )
            }
        }
        .flex(direction: .column)
        .padding(on: .sm)
        .margins(at: .vertical)
        .spacing(of: 4, along: .y)
        .render()
    }
}

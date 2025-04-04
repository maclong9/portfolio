import Foundation
import WebUI

struct Layout: HTML {
  let heading: String
  let description: String
  // Optional Article properties
  let date: Date?
  let image: String?

  let children: [any HTML]

  init(
    heading: String,
    description: String,
    date: Date? = nil,
    image: String? = nil,
    @HTMLBuilder children: @escaping () -> [any HTML]
  ) {
    self.heading = heading
    self.description = description
    self.date = date
    self.image = image
    self.children = children()
  }

  public func render() -> String {
    Stack {
      Header {
        Link(to: "/", label: "Mac Long")
        Navigation {
          Link(to: "https://github.com/maclong9", label: Icon.github.rawValue)
        }
      }
      .flex(justify: .between, align: .center)
      .frame(width: .screen, maxWidth: .fixed(200))
      .margins(.horizontal, auto: true)
      .padding()

      Main {
        if let date = date {
          Section {
            Time(datetime: date.formatted()) { date.formatted() }
            Heading(level: .one) { heading }
              .font(size: .xl4, weight: .bold, tracking: .tight, color: .zinc(._100))
              .border(radius: (side: .all, size: .full))
            Text { description }.margins(.vertical)
            Image(source: image ?? "/placeholder.png", description: "\(heading) cover")
          }
          .margins(.bottom)
        } else {
          Section {
            Heading(level: .one) { heading }
              .font(size: .xl4, weight: .bold, tracking: .tight, color: .zinc(._100))
              .border(radius: (side: .all, size: .full))
            Text { description }.margins(.vertical)
          }
          .margins(.bottom)
        }

        children.map { $0.render() }.joined()
      }
      .flex(grow: .one)
      .margins(.horizontal, auto: true)
      .frame(maxWidth: .character(64))
      .padding()

      Footer {
        if date != nil {
          Stack {
            Text { "Mac Long" }
          }
          Anchor(to: "/articles") { "Read more" }
        } else {
          Text {
            "© \(Date().formattedYear()) "
            Link(to: "/", label: "Mac Long")
          }
        }
      }
      .font(size: .sm, color: .zinc(._600))
      .flex(justify: .center, align: .center)
      .padding()
    }
    .frame(minHeight: .screen)
    .font(color: .zinc(._400))
    .background(color: .zinc((._900)))
    .flex(direction: .column)
    .render()
  }
}

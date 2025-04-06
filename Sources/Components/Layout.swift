import Foundation
import WebUI

struct Layout: HTML {
  let heading: String
  let description: String
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
        Anchor(to: "/") { "Mac Long" }.styled(bold: true)
        Navigation {
          Anchor(to: "https://github.com/maclong9", newTab: true) { Icon.github.rawValue }.styled()
        }
      }
      .flex(justify: .between, align: .center)
      .frame(width: .screen, maxWidth: .fixed(200))
      .margins(.horizontal, auto: true)
      .padding()

      Main {
        Section {
          if let date = date {
            Time(datetime: date.formatted()) { "\(date.formatted(date: .long, time: .shortened).dropLast(2))" }
          }
          Heading(level: .one) { heading }.styled(size: .xl4)
            .margins(.bottom)
          if let image = image {
            Image(source: "\(image)", description: "\(heading) cover", classes: ["w-[120%] max-w-none -ml-[10%] aspect-4/3 rounded-lg shadow-lg"])
          }
          Text { description }.margins(.top)
        }
        .margins(.bottom, length: 10)

        children.map { $0.render() }.joined()
      }
      .flex(grow: .one)
      .margins(.horizontal, auto: true)
      .frame(maxWidth: .character(64))
      .font(wrapping: .pretty)
      .padding()

      Footer {
        Text {
          "© \(Date().formattedYear()) "
          Anchor(to: "/") { "Mac Long" }.styled()
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

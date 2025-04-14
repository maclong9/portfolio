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
        Anchor(to: "/portfolio", config: .init(classes: [temporaryLinkStyles, "font-bold"])) { "Mac Long" }
        Navigation {
          Anchor(
            to: "https://github.com/maclong9", newTab: true,
            config: .init(classes: [temporaryLinkStyles], label: "Visit Mac Long's GitHub profile")
          ) { Icon.github.rawValue }
        }
      }
      .flex(justify: .between, align: .center)
      .frame(width: .screen, maxWidth: .fixed(200))
      .margins(.horizontal, auto: true)
      .padding()

      Main {
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
          Anchor(to: "/portfolio", config: .init(classes: [temporaryLinkStyles])) { "Mac Long" }
        }
      }
      .font(size: .sm, color: .zinc(._400, opacity: 0.9))
      .flex(justify: .center, align: .center)
      .padding()
    }
    .frame(minHeight: .screen)
    .font(color: .zinc(._400))
    .background(color: .zinc((._950)))
    .flex(direction: .column)
    .render()
  }
}

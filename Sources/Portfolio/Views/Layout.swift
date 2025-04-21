import Foundation
import WebUI

struct Layout: HTML {
  let date: Date?
  let image: String?
  let children: [any HTML]

  init(
    date: Date? = nil,
    image: String? = nil,
    @HTMLBuilder children: @escaping () -> [any HTML]
  ) {
    self.date = date
    self.image = image
    self.children = children()
  }

  public func render() -> String {
    let childrenContent = children.map { $0.render() }.joined()

    return Stack {
      Header {
        Link(to: "/portfolio", classes: [temporaryLinkStyles, "font-bold"]) {
          "Mac Long"
        }
        Navigation {
          Link(
            to: "https://github.com/maclong9",
            newTab: true,
            classes: [temporaryLinkStyles],
            label: "Visit Mac Long's GitHub profile"
          ) { Icon.github.rawValue }
        }
      }
      .flex(justify: .between, align: .center)
      .frame(width: .screen, maxWidth: .fixed(200))
      .margins(.horizontal, auto: true)
      .padding()

      Main {
        childrenContent
      }
      .flex(grow: .one)
      .margins(.horizontal, auto: true)
      .frame(maxWidth: .custom("95vw"))
      .frame(maxWidth: .fixed(180), on: .sm)
      .font(wrapping: .pretty)
      .padding()

      Footer {
        Text {
          "© \(Date().formattedYear()) "
          Link(to: "/portfolio", classes: [temporaryLinkStyles]) { "Mac Long" }
        }
      }
      .font(size: .sm, color: .zinc(._400, opacity: 0.9))
      .flex(justify: .center, align: .center)
      .padding()
    }
    .frame(minHeight: .screen)
    .font(color: .zinc(._200))
    .background(color: .zinc(._950))
    .flex(direction: .column)
    .render()
  }
}

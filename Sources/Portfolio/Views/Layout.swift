import Foundation
import WebUI

struct PageHeader: HTML {
  let title: String
  let description: String
  let published: Date?

  func render() -> String {
    Stack {
      Heading(level: .one) { title }
        .styled(size: .xl4)
        .margins(.bottom)
      if let published = published {
        Text {
          Text { "Published: " }
            .font(weight: .bold, family: "system-ui")
          "\(published.formatted(date: .complete, time: .omitted))"
        }.margins(.vertical)
      }
      Text { description }
    }
    .font(family: "ui-serif")
    .flex(direction: .column)
    .render()
  }
}

struct Layout: HTML {
  let title: String
  let description: String
  let published: Date?
  let children: [any HTML]

  init(
    title: String,
    description: String,
    published: Date? = nil,
    @HTMLBuilder children: @escaping () -> [any HTML]
  ) {
    self.title = title
    self.description = description
    self.published = published
    self.children = children()
  }

  public func render() -> String {
    let childrenContent = children.map { $0.render() }.joined()

    return Stack {
      Header {
        Link(to: "/") {
          "Mac Long"
        }.styled().font(size: .xl2)
        Navigation {
          Link(to: "/projects") { "Projects" }.styled().font(size: .sm, weight: .semibold)
          Link(
            to: "https://github.com/maclong9",
            newTab: true,
            label: "Visit Mac Long's GitHub profile",
          ) { Icon.github.rawValue }.styled()
        }.flex(align: .center).spacing(.x)
      }
      .flex(justify: .between, align: .center)
      .frame(width: .screen, maxWidth: .fixed(200))
      .margins(.horizontal, auto: true)
      .border(.bottom, length: 1, color: .neutral(._500, opacity: 0.5)
      .padding()

      Main {
        PageHeader(
          title: title,
          description: description,
          published: published,
        )
        childrenContent
      }
      .flex(grow: .one)
      .margins(.horizontal, auto: true)
      .frame(maxWidth: .custom("99vw"))
      .frame(maxWidth: .fixed(180), on: .sm)
      .font(wrapping: .pretty)
      .padding()

      Footer {
        Text {
          "© \(Date().formattedYear()) "
          Link(to: "/") { "Mac Long" }.styled().font(weight: .normal)
        }
      }
      .font(size: .sm, color: .zinc(._600, opacity: 0.9))
      .font(color: .zinc(._400, opacity: 0.9), on: .dark)
      .flex(justify: .center, align: .center)
      .padding()
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

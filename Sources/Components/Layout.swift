import Foundation
import WebUI

struct ArticleData {
  let date: Date
  let title: String
  let description: String
  let image: String
  let content: HTML
}

struct Layout: HTML {
  struct Social {
    let icon: Icon
    let url: String
  }

  let heading: String
  let description: String
  let socials: [Social]?
  // Optional Article properties
  let date: Date?
  let image: String?
  

  let children: [any HTML]

  init(
    heading: String,
    description: String,
    socials: [Social]? = nil,
    date: Date? = nil,
    image: String? = nil,
    @HTMLBuilder children: @escaping () -> [any HTML]
  ) {
    self.heading = heading
    self.description = description
    self.socials = socials
    self.date = date
    self.image = image
    self.children = children()
  }

  public func render() -> String {
    Stack {
      Header {
        Link(to: "/", label: "Mac Long", bold: true)
        Navigation {
          for route in Portfolio.staticRoutes {
            Link(to: "/\(String(describing: route.path))", label: route.metadata.title)
          }
        }
        .shadow(size: .lg)
        .flex(justify: .center, align: .center)
        .border(radius: (side: .all, size: .full))
        .ring(size: 1, color: .zinc(._100, opacity: 0.1))
        .padding(.horizontal, length: 3)
        .padding(.vertical, length: 2)
        .font(size: .sm)
        .spacing(.x, length: 2)
      }
      .flex(justify: .between, align: .center)
      .frame(width: .screen, maxWidth: .fixed(200))
      .margins(.horizontal, auto: true)
      .padding()

      Main {
        if let date = date {
          // Article-specific header section
          Section {
            Time(datetime: date.formatted()) { date.formatted() }
            Heading(level: .one) { heading }
              .font(size: .xl5, weight: .bold, tracking: .tight, color: .zinc(._100))
              .border(radius: (side: .all, size: .full))
            Text { description }.margins(.vertical)
            Image(source: image ?? "/placeholder.png", description: "\(heading) cover")
          }
          .margins(.bottom)
        } else {
          // Default root header section
          Section {
            Heading(level: .one) { heading }
              .font(size: .xl5, weight: .bold, tracking: .tight, color: .zinc(._100))
              .border(radius: (side: .all, size: .full))
            Text { description }.margins(.vertical)
            if let socials {
              Navigation {
                for social in socials {
                  Anchor(to: social.url, newTab: true) { "\(social.icon.rawValue)" }
                }
              }
              .flex(align: .center)
              .spacing(.x, length: 1)
            }
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
    .font(color: .zinc(._100))
    .background(color: .zinc((._900)))
    .flex(direction: .column)
    .render()
  }
}

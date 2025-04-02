import Foundation
import WebUI

struct Card: HTML {
  let icon: String?
  let title: String
  let description: String
  let date: Date?
  let url: String?

  init(icon: String? = nil, title: String, description: String, date: Date? = nil, url: String? = nil) {
    self.icon = icon
    self.title = title
    self.description = description
    self.date = date
    self.url = url
  }

  func render() -> String {
    Item {
      if let icon { icon }
      Stack {
        if let date { Time(datetime: date.formatted()) { date.formatted() } }
        Heading(level: .two) { title }
      }
      Text { description }
      if let url {
        Anchor(to: url) {
          "🔗 Learn more"
          Stack().position(.absolute, edges: .all)
        }
      } else {
        Anchor(to: "/articles\(title.slugified())") { "Read article ›" }
      }
    }
    .position(.relative)
    .render()
  }
}

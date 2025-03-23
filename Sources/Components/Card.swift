import Foundation
import WebUI

struct Card: HTML {
  let icon: String?
  let title: String
  let description: String
  let date: Date?
  let url: String?

  func render() -> String {
    Stack {
      if let icon { icon }
      Stack {
        if let date { Time(datetime: date.formatted()) { date.formatted() } }
        Heading(level: .two) { title }
      }
      Text { description }
      if let url {
        Link(to: url) { "🔗 Learn more" }
      } else {
        Link(to: "/articles\(title.slugified())") { "Read article ›" }
      }
    }.render()
  }
}

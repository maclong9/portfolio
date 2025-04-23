import Foundation
import WebUI

struct Card: HTML {
  let title: String
  let url: String
  let description: String
  let technologies: [String]?
  let publishedDate: Date?

  func render() -> String {
    Link(to: url, newTab: technologies != nil) {
      Article {
        Stack {
          Heading(level: .two) { title }.styled(size: .lg)

          if let technologies = technologies {
            Stack {
              for technology in technologies {
                Text { technology }
                  .background(color: .zinc(._300))
                  .background(color: .zinc(._600), on: .dark)
                  .border(edges: .all, radius: (side: .all, size: .lg))
                  .font(size: .xs, color: .zinc(._900))
                  .font(color: .zinc(._200), on: .dark)
                  .padding(.horizontal, length: 2)
                  .padding(.vertical, length: 1)
                  .margins(.trailing, length: 1)
              }
            }.padding(.bottom, length: 2)
          }
        }.flex(direction: .row).spacing(.x, length: 3)

        if let date = publishedDate {
          Time(datetime: "\(date.ISO8601Format())") {
            "\(date.formatted(date: .complete, time: .omitted))"
          }
          .font(size: .sm, color: .zinc(._600, opacity: 0.9))
          .font(color: .zinc(._400, opacity: 0.9), on: .dark)
        }

        Text { description }
          .font(size: .sm, family: "ui-serif")
          .margins(.top, length: 2)
          .margins(.bottom, length: 3)

        Text { "Source code ›" }
          .font(size: .sm, weight: .semibold, color: .teal(._500))
      }
      .cursor(.pointer)
      .flex(direction: .column, align: .start)
      .border(edges: .all, radius: (side: .all, size: .lg))
      .background(color: .zinc(._300), on: .hover)
      .background(color: .zinc(._700), on: .hover, .dark)
      .transition(property: .colors, duration: 300, easing: .inOut)
      .padding()
    }.render()
  }
}

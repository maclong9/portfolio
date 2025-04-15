import Foundation
import WebUI

struct Home: HTML {
  func render() -> String {
    Layout {
      Heading(level: .one) { "Software engineer, skater, & musician." }.styled(size: .xl4).margins(.bottom)
      Text {
        "I'm Mac, a software engineer based out of the United Kingdom. I enjoy working on open source projects and building things that make people's lives easier. Read some of my articles below."
      }
      Stack {
        Anchor(to: "/portfolio/articles/personal-setup") {
          Article {
            Heading(level: .two) { "Personal Setup" }.styled(size: .lg)
            Text {
              "This is a collection of tools and software that I find indispensable for my daily work as a software engineer."
            }
            .font(size: .sm)
            .margins(.top, length: 2)
            .margins(.bottom, length: 3)
            Text { "Read more ›" }
              .font(size: .sm, weight: .semibold, color: .teal(._600))
          }
          .cursor(.pointer)
          .flex(direction: .column, align: .start)
          .border(edges: .all, radius: (side: .all, size: .lg))
          .background(color: .zinc(._700), on: .hover)
          .transition(property: .colors, duration: 300, easing: .inOut)
          .padding()
        }
      }.flex(direction: .column).spaced()
    }.render()
  }
}

import Foundation
import WebUI

struct Home: HTML {
  func render() -> String {
    return Layout(
      heading: "Software engineer, skater, & musician.",
      description:
        "I'm Mac, a software engineer based out of the United Kingdom. I enjoy working on open source projects and building things that make people's lives easier. Read some of my articles below."
    ) {
      Stack {
        for article in Portfolio.articleRoutes {
          Anchor(to: "/portfolio/articles/\(article.metadata.title.slugified())") {
            Article {
              Heading(level: .two) { article.metadata.title }.styled(size: .lg)

              Text { article.metadata.description }
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
        }
      }.flex(direction: .column)
    }.render()
  }
}

import Foundation
import WebUI

struct Home: HTML {
  struct Experience {
    let title: String
    let position: String
    let startDate: String
    let endDate: String
  }

  func render() -> String {
    Layout(
      heading: "Software engineer, skater, & musician.",
      description:
        "I’m Mac, a software engineer based out of the United Kingdom. I enjoy working on open source projects and building things that make people’s lives easier.",
    ) {
      Stack {
        for article in Portfolio.articleRoutes {
          Anchor(to: "/articles/\(article.metadata.title.slugified())") {
            Article {
              Time(datetime: "\(String(describing: article.metadata.date))") {
                "\(String(describing: article.metadata.date))"
              }
              .opacity(50)
              .border(width: 2, edges: .leading, color: .zinc(._300, opacity: 0.5))
              .font(weight: .light)
              .padding(.leading, length: 2)

              Heading(level: .two) { article.metadata.title }
                .font(size: .base, weight: .bold, tracking: .tight, color: .zinc(._100))
                .margins(.bottom, length: 2)

              Text { article.metadata.description }
                .font(size: .sm)
            }
          }
          .position(.relative)
          .flex(direction: .column, align: .start)
        }
      }
    }.render()
  }
}

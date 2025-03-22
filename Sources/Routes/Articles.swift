import Foundation
import WebUI

struct Articles: HTML {
  func render() -> String {
    RootLayout {
      Hero(
        heading: "Writing on software, productivity, and personal growth",
        text:
          "All of my long-form thoughts on programming, leadership, product design, and more, collected in chronological order."
      )
      Section {
        List {
          // for loop of articles
        }
      }
    }.render()
  }
}

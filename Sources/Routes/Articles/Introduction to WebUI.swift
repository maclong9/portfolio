import Foundation
import WebUI

struct WebUIIntroduction: HTML {
  func render() -> String {
    Article {
      Section {
        Header {
          Heading(level: .two) { "What is WebUI?" }.styled(size: .xl3)
          Text {
            ""
          }
        }
      }

      Section {
        Header {
          Heading(level: .two) { "Why Did I Build It?" }.styled(size: .xl3)
        }
        Main {
          Stack {
            Heading(level: .three) { "14\" MacBook Pro, M3 Pro, 18GB RAM" }.styled(size: .lg)
            Text {
              ""
            }
          }.spaced()
        }
      }.spaced()
    }.render()
  }
}


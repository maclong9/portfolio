import Foundation
import WebUI

struct Layout: HTML {
  let children: [any HTML]

  init(@HTMLBuilder children: @escaping () -> [any HTML]) {
    self.children = children()
  }

  let NavigationLinks = Navigation {
    Link(to: "/") { "Home" }
    Link(to: "/articles") { "Articles" }
    Link(to: "/projects") { "Projects" }
    Link(to: "/uses") { "Uses" }
  }

  func render() -> String {
    Fragment {
      Header {
        NavigationLinks
      }

      Main {
        children.map { $0.render() }.joined()
      }

      Footer {
        Text { "© \(Date().formattedYear()) Mac Long" }
        NavigationLinks
      }
    }.render()
  }
}

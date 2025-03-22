import Foundation
import WebUI

struct RootLayout: HTML {
  let isHome: Bool
  let children: [any HTML]

  init(isHome: Bool = false, @HTMLBuilder children: @escaping () -> [any HTML]) {
    self.isHome = isHome
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
        if !isHome { Avatar() }
        NavigationLinks
        Button { "🍎" }
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

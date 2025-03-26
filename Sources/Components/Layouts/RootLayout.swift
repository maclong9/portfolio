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
  .shadow(size: .lg)
  .flex(direction: .row, justify: .around, align: .center)
  .border(radius: (side: .all, size: .md))

  func render() -> String {
    Fragment {
      Header {
        if !isHome { Avatar() } else { "" }
        NavigationLinks
        Button { "🍎" }
          .border(radius: (side: .all, size: .lg))
      }
      .flex(justify: .evenly, align: .center)

      Main {
        children.map { $0.render() }.joined()
      }

      Footer {
        NavigationLinks
        Text { "© \(Date().formattedYear()) Mac Long" }
      }
      .font(size: .sm)
      .flex(justify: .evenly, align: .center)
    }.render()
  }
}

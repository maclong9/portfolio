import WebUI

// snippet.LAYOUT
// Components in WebUI are defined in a struct that conforms to the ``HTML`` type.
struct LayoutOne: HTML {
  let children: [any HTML]

  init(@HTMLBuilder children: @escaping () -> [any HTML]) {
    self.children = children()
  }

  public func render() -> String {
    Stack {
      Header {
        Anchor(to: "/") { "Site Title" }
        Navigation {
          Anchor(to: "https://github.com/maclong9", newTab: true) { "GitHub" }
        }
      }
      .flex(justify: .between, align: .center)
      .frame(width: .screen, maxWidth: .fixed(200))
      .margins(.horizontal, auto: true)
      .padding()

      Main {
        children.map { $0.render() }.joined()
      }
      .flex(grow: .one)
      .margins(.horizontal, auto: true)
      .frame(maxWidth: .custom("95vw"))
      .frame(maxWidth: .character(64), on: .sm)
      .font(wrapping: .pretty)
      .padding()

      Footer {
        Text {
          "© \(Date().formattedYear()) "
          Anchor(to: "/") { "Site Title" }
        }
      }
      .font(size: .sm, color: .zinc(._400, opacity: 0.9))
      .flex(justify: .center, align: .center)
      .padding()
    }
    .frame(minHeight: .screen)
    .font(color: .zinc(._200))
    .background(color: .zinc((._950)))
    .flex(direction: .column)
    .render()
  }
}

// snippet.STATIC
public struct StaticSite: Sendable {
  var staticRoutes: [Document] {
    [
      Document(
        path: "index",
        metadata: .init(
          title: "Home",
          description: "Description goes here.",
        ),
        content: {
          Layout {
            Heading(level: .one) { "Home Page" }
            Anchor(to: "/about") { "Go to About" }
          }
        }
      ),
      Document(
        path: "about",
        metadata: .init(
          title: "About",
          description: "Software Engineer, crafting intuitive solutions.",
        ),
        content: {
          Layout {
            Heading(level: .one) { "About Page" }
            Anchor(to: "/") { "Go to Home" }
          }
        }
      )
    ]
  }

  func main() async throws {
    try Application(routes: staticRoutes).build(publicDirectory: "Sources/Static Site/Public")
  }
}

// snippet.IMAGE
let image = Image(source: "public/image.jpg", description: "An image for web rendering")

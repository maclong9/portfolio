import WebUI

let document = Document(
  metadata: Metadata(
    site: "Awesome Site",
    title: "Some Page",
    titleSeperator: "-",
    description: "This is my awesome page",
    date: Date(),
    image: "/og.png",
    author: "Your Name",
    keywords: ["swift", "webui"],
    twitter: "@username",
    locale: .en,
    type: .website
  )
) {
  Header { "Hello, World!" }
  Main {
    Heading(level: .one) { "This is my awesome page." }
    List {
      Item { "Item 1" }
      Item { "Item 2" }
    }
    Anchor(to: "https://github.com/maclong9/web-ui", newTabe: true) { "WebUI Repository" }
  }.render()
}

let html = document.render()

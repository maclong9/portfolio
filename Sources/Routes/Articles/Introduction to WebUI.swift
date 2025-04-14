import Foundation
import WebUI

struct WebUIIntroduction: HTML {
  let children: [any HTML]

  init(@HTMLBuilder children: @escaping () -> [any HTML]) {
    self.children = children()
  }

  func render() -> String {
    Article {
      ArticleSection(title: "What is WebUI?") {
        Text {
          "WebUI is a Swift-based web framework designed for building fast, secure, and performant web applications. Its declarative syntax, inspired by SwiftUI, allows developers to create HTML, CSS, and JavaScript with minimal code. WebUI prioritizes simplicity, making it ideal for static sites and dynamic applications alike."
        }
      }

      ArticleSection(title: "Why Did I Build It?") {
        ContentStack(title: "Addressing Tooling Gaps") {
          Text {
            "Existing frameworks like \(Anchor(to: "https://github.com/slimeobn/elementary", newTab: true) { "Elementary" }) offered some of what I needed, but often fell short in customization or ease of use. I built WebUI to streamline my workflow, leveraging Swift’s type safety and a SwiftUI-like syntax to create a framework tailored to my styling preferences and long-term maintenance needs."
          }
        }
      }

      ArticleSection(title: "Key Features") {
        ContentStack(title: "Declarative Syntax") {
          Text {
            "WebUI’s declarative approach lets you define your UI hierarchically, mirroring SwiftUI. This makes it intuitive to structure complex layouts with minimal boilerplate."
          }
        }

        ContentStack(title: "Rich Component Library") {
          Text {
            "The framework provides components like \(Code { "Article" }), \(Code { "Heading" }), and \(Code { "Image" }), all styled with Tailwind CSS via the \(Code { "styled" }) method for flexibility."
          }
        }

        ContentStack(title: "Efficient Static Builds") {
          Text {
            "WebUI generates minified HTML for static sites, optimized for performance and SEO. The \(Code { "Application" }) struct manages routes and builds your site with ease."
          }
        }
      }

      ArticleSection(title: "Example Usage") {
        ContentStack(title: "Building a Simple Page") {
          Text {
            "Below is an example of a basic WebUI page with a heading and an image:"
          }
          Preformatted {
            Code {
              """
              import WebUI

              struct SimplePage: HTML {
                  func render() -> String {
                      Article {
                          ArticleSection(title: "Hello, WebUI!") {
                              Text { "Welcome to my first WebUI page." }
                              Image(
                                  source: "/images/sample.jpg",
                                  description: "Sample image"
                              )
                          }
                      }.render()
                  }
              }
              """
            }
          }
        }

        ContentStack(title: "Adding Metadata") {
          Text {
            "WebUI simplifies SEO with the Metadata and Document structs:"
          }
          Preformatted {
            Code {
              """
              let metadata = Metadata(
                  title: "Simple Page",
                  description: "A WebUI demo page",
                  image: "/images/sample.jpg",
                  type: .article
              )

              let document = Document(
                  path: "/simple-page",
                  metadata: metadata
              ) {
                  SimplePage()
              }
              """
            }
          }
        }
      }
    }.render()
  }
}

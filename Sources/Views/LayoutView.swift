import Vapor
import SwiftHtml

struct LayoutView: TemplateRepresentable {
  let context: LayoutContext
  let stylesheet: String
  
  init(_ context: LayoutContext, _ stylesheet: String) {
    self.context = context
    self.stylesheet = stylesheet
  }
  
  func render(_ req: Request) -> Tag {
    Html {
      Head {
        Meta().charset("utf-8")
        Meta().name(.viewport).content("width=device-width, initial-scale=1")
        Title(context.title)
        Meta().name(.description).content(context.description)
        Meta().name("theme-color").content(context.theme)
        Meta().name("og:title").content(context.title)
        Meta().name("og:description").content(context.description)
        Meta().name("og:image").content(context.image)
        Meta().name("og:url").content(context.url)
        Meta().name("og:type").content(context.type)
        Meta().name("twitter:card").content("summary_large_image")
        Meta().name("twitter:title").content(context.title)
        Meta().name("twitter:description").content(context.description)
        Meta().name("twitter:url").content(context.url)
        Meta().name("twitter:image").content(context.image)
        Style(stylesheet)
      }
      
      Body {
        Header {
          Button("M").id("nav-button").onClick("toggleMenu()")
          Nav {
            A("Home").href("/")
            A("Blog").href("/blog")
            A("GitHub").href("https://github.com/maclong9").target(.blank).class("nav-highlight")
          }
        }
        
        context.body
        
        Footer {
          Span("Copyright © 2024 Mac Long. All rights reserved.")
        }
        Script().src("main.js")
      }
    }
  }
}

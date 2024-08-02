import Foundation
import SwiftCss

struct StylesheetGenerator {
  let context: StylesContext
  private var stylesheets: [Stylesheet] = []
  
  init(_ context: StylesContext) {
    self.context = context
  }
  
  mutating func addModules(_ stylesheets: [Stylesheet]) {
    for stylesheet in stylesheets {
      self.stylesheets.append(stylesheet)
    }
  }
  
  mutating func render() -> String {
    let renderedStylesheets = stylesheets.map {
      StylesheetRenderer(minify: true).render($0)
    }
    
    return renderedStylesheets.joined(separator: "\n")
  }
}

var stylesheetGenerator = StylesheetGenerator(
  StylesContext(
    colors: StylesContext.Colors(
      background: "#1c1c1c",
      foreground: "#fefefe",
      primary: "#0099ff",
      secondary: "#0e7490"
    ),
    fonts: StylesContext.Fonts(
      heading: "system-ui",
      body: "system-ui",
      monospaced: "ui-monospaced"
    ),
    radius: .medium
  )
)

let colors = stylesheetGenerator.context.colors
let fonts = stylesheetGenerator.context.fonts
let radius = stylesheetGenerator.context.radius

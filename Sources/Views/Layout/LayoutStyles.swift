import SwiftCss

let LayoutStyles = Stylesheet {
  Media {
    Selector("html, body") {
      Background(colors.background)
      Color(colors.foreground)
      FontFamily(fonts.body)
    }
  }
}

import SwiftCss

let HomeStyles = Stylesheet {
  Media {
    Selector("#about") {
      BackgroundColor(colors.background)
      Color(colors.foreground)
      FontFamily(fonts.heading)
      Padding(1.rem)
    }
    Selector(".skills") {
      Display(.flex)
      FlexDirection(.column)
      BackgroundColor(colors.primary)
    }
    Selector(".skill-button") {
      BackgroundColor(colors.secondary)
      Color(.white)
      Padding(1.rem)
    }
  }
}

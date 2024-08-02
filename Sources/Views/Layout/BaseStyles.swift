import SwiftCss

let BaseStyles = Stylesheet {
  Media {
    Selector("html, body") {
      FontStyle("normal")
      FontVariant("normal")
      FontWeight("normal")
      FontSize(typography.size)
      LineHeight(typography.lineHeight)
      LetterSpacing(typography.letterSpacing)
      FontFamily(typography.body)
      Background(colors.background)
      Color(colors.foreground)
    }
    
    Selector("a") {
      Color(colors.foreground)
      TextDecoration("underline")
      Cursor("pointer")
      Transition("color .2s ease-in-out")
    }
    Selector("a") {
      Color(colors.primary)
    }.pseudo(.hover)
    
    Selector("h1, h2, h3, h4, h5, h6") {
      FontFamily(typography.heading)
    }
    
    Selector("main") {
      Display(.flex)
      FlexDirection(.column)
      AlignItems(.center)
    }
    
    Selector("section") {
      Width(100.pc)
      MaxWidth(65.ch)
      Padding(horizontal: 0.rem, vertical: 1.rem)
      Margin(horizontal: 1.rem, vertical: 0.rem)
    }
  }
  
  Media(screen: .l) {
    Selector("html, body") {
      FontSize(.large)
    }
  }
}

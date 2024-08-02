import SwiftCss

let LayoutStyles = Stylesheet {
  Media {
    Selector("header") {
      Position(.fixed)
      Top(2.5.pc)
      Right(5.pc)
    }
    
    Selector("header button, header nav") {
      Position(.absolute)
      Top(2.5.pc)
      Right(5.pc)
    }
    
    Selector("header button") {
      Width(3.rem)
      Height(3.rem)
      Color(colors.foreground)
      Background(
        "linear-gradient(135deg, \(colors.primary), \(colors.faded)"
      )
    }
    Selector("header button[data-attribute='true']") {
      Transform(.scale(1, 1))
      Opacity(1)
    }
    Selector("header button svg") {
      Width(60.pc)
      Height(60.pc)
      Margin("auto")
    }

    Selector("header nav") {
      // ...r
    }
  }
}

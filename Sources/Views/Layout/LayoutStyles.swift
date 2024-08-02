import SwiftCss

let LayoutStyles = Stylesheet {
  Media {
    Selector("header") {
      Position(.fixed)
      Top(2.5.pc)
      Right(5.pc)
    }
    
    Selector("header button, nav button") {
      Position(.absolute)
      Top(2.5.pc)
      Right(5.pc)
    }
    
    Selector("button") {
      Width(3.rem)
      Height(3.rem)
      Color(colors.foreground)
      Background(
        "linear-gradient(135deg, \(colors.primary), \(colors.faded)"
      )
    }
  }
}

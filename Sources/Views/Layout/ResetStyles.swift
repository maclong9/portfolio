import SwiftCss

let ResetStyles = Stylesheet {
  Media {
    All {
      BoxSizing(.borderBox)
      Margin(0.rem)
      Padding(0.rem)
    }
    
    Selector("body") {
      Property(name: "webkit-font-smoothing", value: "antialiased")
      Property(name: "text-rendering", value: "optimizeLegibility")
    }
    
    Selector("img, picture, video, canvas, svg") {
      Display(.block)
      MaxWidth(.percent(100))
    }
    
    Selector("input, button, textarea, select") {
      Font(.inherit)
    }
  }
  
  Media("print") {
    Selector("header, footer") {
      Display("none")
    }
    
    Selector("main") {
      Width(100.pc)
      MaxWidth("none")
    }
    
    Selector("a") {
      TextDecoration("none")
    }
    
    Selector("h1, h2, h3") {
      PageBreakAfter(.avoid)
    }
    
    Selector("img") {
      MaxWidth(100.pc)
    }
    
    Selector("@page") {
      Margin(2.cm)
    }
  }
}

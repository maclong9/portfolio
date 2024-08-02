import SwiftHtml

struct StylesContext {
  struct Colors {
    let background: String
    let foreground: String
    let primary: String
    let secondary: String
  }
  
  struct Fonts {
    let heading: String
    let body: String
    let monospaced: String
  }
  
  enum RadiusValue {
    case none, small, medium, large, extraLarge
  }
  
  let colors: Colors
  let fonts: Fonts
  let radius: RadiusValue
}

struct LayoutContext {
  let title: String
  let description: String
  let url: String = "https://maclong.tech"
  var type: String = "website"
  var image: String = "og.webp"
  var theme: String = "#000"
  let body: Tag
}

struct Skill {
  let name: String
  let description: String
  let icon: String
}

struct Project {
  let name: String
  let summary: String
  let tag: String
  let url: String
  var new: Bool = false
  var hidden: Bool = false
}

struct HomeProps {
  let skills: [Skill]
  let projects: [Project]
}

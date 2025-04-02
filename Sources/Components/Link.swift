import WebUI

struct Link: HTML {
  let href: String
  let label: String
  let newTab: Bool
  let bold: Bool

  init(to href: String, label: String, newTab: Bool = false, bold: Bool = false) {
    self.href = href
    self.label = label
    self.newTab = newTab
    self.bold = bold
  }

  func render() -> String {
    Anchor(to: href, newTab: newTab) { label }
      .cursor(.pointer)
      .transition(property: .colors, duration: 300)
      .font(weight: bold ? .bold : .normal)
      .font(color: .teal(._600), on: .hover)
      .render()
  }
}
